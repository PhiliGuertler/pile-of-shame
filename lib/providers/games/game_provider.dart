import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_group_provider.dart';
import 'package:pile_of_shame/providers/games/game_search_provider.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.g.dart';

@riverpod
FutureOr<List<Game>> games(GamesRef ref) async {
  final database = await ref.watch(databaseProvider.future);
  return database.games;
}

@riverpod
FutureOr<List<Game>> gamesByPlatform(
  GamesByPlatformRef ref,
  GamePlatform platform,
) async {
  final games = await ref.watch(gamesProvider.future);

  return games.where((element) => element.platform == platform).toList();
}

@riverpod
FutureOr<List<Game>> gamesByPlatformFamily(
  GamesByPlatformFamilyRef ref,
  GamePlatformFamily family,
) async {
  final games = await ref.watch(gamesProvider.future);

  return games.where((element) => element.platform.family == family).toList();
}

@riverpod
FutureOr<List<Game>> gamesByPlayStatus(
  GamesByPlayStatusRef ref,
  List<PlayStatus> statuses,
) async {
  final games = await ref.watch(gamesProvider.future);

  return games.where((element) => statuses.contains(element.status)).toList();
}

@riverpod
FutureOr<bool> hasGames(HasGamesRef ref) async {
  final games = await ref.watch(gamesProvider.future);

  return games.isNotEmpty;
}

@riverpod
FutureOr<List<Game>> gamesFiltered(GamesFilteredRef ref) async {
  final games = await ref.watch(gamesProvider.future);

  final filteredGames = await ref.watch(applyGameFiltersProvider(games).future);
  final searchedGames = ref.watch(applyGameSearchProvider(filteredGames));
  final sortedGames =
      await ref.watch(applyGameSortingProvider(searchedGames).future);

  return sortedGames;
}

@riverpod
FutureOr<Game> gameById(GameByIdRef ref, String id) async {
  final games = await ref.watch(gamesProvider.future);

  try {
    return games.singleWhere((element) => element.id == id);
  } catch (error) {
    throw Exception("No game with id '$id' found");
  }
}

@riverpod
FutureOr<DLC> dlcByGameAndId(
  DlcByGameAndIdRef ref,
  String gameId,
  String dlcId,
) async {
  final game = await ref.watch(gameByIdProvider(gameId).future);
  try {
    return game.dlcs.singleWhere((element) => element.id == dlcId);
  } catch (error) {
    throw Exception("No dlc with id '$dlcId' found");
  }
}

@riverpod
FutureOr<double> gamesFilteredTotalPrice(GamesFilteredTotalPriceRef ref) async {
  final list = await ref.watch(gamesFilteredProvider.future);

  final sum = list.fold(
    0.0,
    (previousValue, element) => previousValue + element.fullPrice(),
  );
  return sum;
}

@riverpod
FutureOr<int> gamesFilteredTotalAmount(GamesFilteredTotalAmountRef ref) async {
  final list = await ref.watch(gamesFilteredProvider.future);

  return list.length;
}

@riverpod
FutureOr<Map<String, List<Game>>> gamesGrouped(GamesGroupedRef ref) async {
  final filteredGames = await ref.watch(gamesFilteredProvider.future);

  return await ref.watch(applyGameGroupProvider(filteredGames).future);
}
