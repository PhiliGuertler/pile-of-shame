import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_group_provider.dart';
import 'package:pile_of_shame/providers/games/game_search_provider.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.g.dart';

@riverpod
FutureOr<List<Game>> games(Ref ref) async {
  final database = await ref.watch(databaseProvider.future);
  return database.games;
}

@riverpod
FutureOr<List<Game>> gamesByPlatform(
  Ref ref,
  GamePlatform platform,
) async {
  final games = await ref.watch(gamesProvider.future);

  return games.where((element) => element.platform == platform).toList();
}

@riverpod
FutureOr<List<Game>> gamesByPlatformFamily(
  Ref ref,
  GamePlatformFamily family,
) async {
  final games = await ref.watch(gamesProvider.future);

  return games.where((element) => element.platform.family == family).toList();
}

@riverpod
FutureOr<List<Game>> gamesByPlayStatus(
  Ref ref,
  List<PlayStatus> statuses,
) async {
  final games = await ref.watch(gamesProvider.future);

  return games.where((element) => statuses.contains(element.status)).toList();
}

@riverpod
FutureOr<List<Game>> gamesByFavorites(
  Ref ref,
) async {
  final games = await ref.watch(gamesProvider.future);

  return games.where((element) => element.isFavorite).toList();
}

@riverpod
FutureOr<List<Game>> gamesWithNotes(
  Ref ref,
) async {
  final games = await ref.watch(gamesProvider.future);

  return games
      .where(
        (element) =>
            (element.notes != null && element.notes!.isNotEmpty) ||
            (element.dlcs
                .any((dlc) => dlc.notes != null && dlc.notes!.isNotEmpty)),
      )
      .toList();
}

@riverpod
FutureOr<bool> hasGames(Ref ref) async {
  final games = await ref.watch(gamesProvider.future);

  return games.isNotEmpty;
}

@riverpod
FutureOr<List<Game>> gamesFiltered(Ref ref) async {
  final games = await ref.watch(gamesProvider.future);

  final filteredGames = await ref.watch(applyGameFiltersProvider(games).future);
  final searchedGames = ref.watch(applyGameSearchProvider(filteredGames));
  final sortedGames =
      await ref.watch(applyGameSortingProvider(searchedGames).future);

  return sortedGames;
}

@riverpod
FutureOr<Game> gameById(Ref ref, String id) async {
  final games = await ref.watch(gamesProvider.future);

  try {
    return games.singleWhere((element) => element.id == id);
  } catch (error) {
    throw Exception("No game with id '$id' found");
  }
}

@riverpod
FutureOr<DLC> dlcByGameAndId(
  Ref ref,
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
FutureOr<double> gamesFilteredTotalPrice(Ref ref) async {
  final list = await ref.watch(gamesFilteredProvider.future);

  final sum = list.fold(
    0.0,
    (previousValue, element) => previousValue + element.fullPrice(),
  );
  return sum;
}

@riverpod
FutureOr<int> gamesFilteredTotalAmount(Ref ref) async {
  final list = await ref.watch(gamesFilteredProvider.future);

  return list.length;
}

@riverpod
FutureOr<Map<String, List<Game>>> gamesGrouped(Ref ref) async {
  final filteredGames = await ref.watch(gamesFilteredProvider.future);

  return await ref.watch(applyGameGroupProvider(filteredGames).future);
}
