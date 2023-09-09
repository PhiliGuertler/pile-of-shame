import 'dart:convert';

import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_storage.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_search_provider.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.g.dart';

@riverpod
GameStorage gameStorage(GameStorageRef ref) => GameStorage(ref: ref);

@riverpod
FutureOr<GamesList> games(GamesRef ref) async {
  final minWaiting = Future.delayed(const Duration(milliseconds: 600));
  final gameFile = await ref.watch(gameFileProvider.future);

  await minWaiting;

  final content = await gameFile.readAsString();
  if (content.isNotEmpty) {
    return GamesList.fromJson(jsonDecode(content));
  }
  return const GamesList(games: []);
}

@riverpod
FutureOr<bool> hasGames(HasGamesRef ref) async {
  final games = await ref.watch(gamesProvider.future);

  return games.games.isNotEmpty;
}

@riverpod
FutureOr<GamesList> gamesFiltered(GamesFilteredRef ref) async {
  final games = await ref.watch(gamesProvider.future);

  final filteredGames = ref.watch(applyGameFiltersProvider(games.games));
  final searchedGames = ref.watch(applyGameSearchProvider(filteredGames));
  final sortedGames =
      await ref.watch(applyGameSortingProvider(searchedGames).future);

  return GamesList(games: sortedGames);
}

@riverpod
FutureOr<Game> gameById(GameByIdRef ref, String id) async {
  final games = await ref.watch(gamesProvider.future);

  return games.games.singleWhere((element) => element.id == id);
}

@riverpod
FutureOr<DLC> dlcByGameAndId(
    DlcByGameAndIdRef ref, String gameId, String dlcId) async {
  final game = await ref.watch(gameByIdProvider(gameId).future);
  return game.dlcs.singleWhere((element) => element.id == dlcId);
}

@riverpod
double gamesFilteredTotalPrice(GamesFilteredTotalPriceRef ref) {
  final games = ref.watch(gamesFilteredProvider);

  return games.when(
    data: (games) => games.games.fold(
      0.0,
      (previousValue, element) => previousValue + element.fullPrice(),
    ),
    error: (error, stackTrace) => 0.0,
    loading: () => 0.0,
  );
}

@riverpod
int gamesFilteredTotalAmount(GamesFilteredTotalAmountRef ref) {
  final games = ref.watch(gamesFilteredProvider);

  return games.when(
    data: (games) => games.games.length,
    error: (error, stackTrace) => 0,
    loading: () => 0,
  );
}
