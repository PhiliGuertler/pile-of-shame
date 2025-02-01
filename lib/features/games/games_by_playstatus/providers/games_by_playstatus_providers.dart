import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/models/games_by_playstatus_models.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/sorter_utils.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'games_by_playstatus_providers.g.dart';

@Riverpod(keepAlive: true)
class GamesByPlayStatusSorter extends _$GamesByPlayStatusSorter
    with Persistable {
  static const String storageKey = "games-by-play-status-sorters";

  @override
  FutureOr<Map<PlayStatus, GameSorting>> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return GamesByPlayStatusSorters.fromJson(storedJSON).sorters;
    }

    return const GamesByPlayStatusSorters().sorters;
  }

  Future<void> setSorting(PlayStatus status, GameSorting sorting) async {
    state = await AsyncValue.guard(() async {
      final Map<PlayStatus, GameSorting> previousValue =
          Map.from(await ref.read(gamesByPlayStatusSorterProvider.future));

      previousValue[status] = sorting;

      final serializable = GamesByPlayStatusSorters(sorters: previousValue);

      await persistJSON(storageKey, serializable.toJson());
      return previousValue;
    });
  }
}

@Riverpod(keepAlive: true)
class FavoriteGamesSorter extends _$FavoriteGamesSorter with Persistable {
  static const String storageKey = "favorite-games-sorter";

  @override
  FutureOr<GameSorting> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return GameSorting.fromJson(storedJSON);
    }
    return const GameSorting();
  }

  Future<void> setSorting(GameSorting sorting) async {
    state = await AsyncValue.guard(() async {
      await persistJSON(storageKey, sorting.toJson());
      return sorting;
    });
  }
}

@Riverpod(keepAlive: true)
class GamesWithNotesSorter extends _$GamesWithNotesSorter with Persistable {
  static const String storageKey = "games-with-notes-sorter";

  @override
  FutureOr<GameSorting> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return GameSorting.fromJson(storedJSON);
    }
    return const GameSorting();
  }

  Future<void> setSorting(GameSorting sorting) async {
    state = await AsyncValue.guard(() async {
      await persistJSON(storageKey, sorting.toJson());
      return sorting;
    });
  }
}

@riverpod
Future<GameSorting> gameSortingByPlayStatus(
  Ref ref,
  PlayStatus status,
) async {
  final sorters = await ref.watch(gamesByPlayStatusSorterProvider.future);

  return sorters[status]!;
}

@riverpod
Future<List<Game>> gamesByPlayStatusesSorted(
  Ref ref,
  List<PlayStatus> statuses,
) async {
  assert(statuses.isNotEmpty);

  final games = await ref.watch(gamesByPlayStatusProvider(statuses).future);

  final sorter =
      await ref.watch(gameSortingByPlayStatusProvider(statuses.first).future);

  return SorterUtils.sortGames(games, sorter);
}

@riverpod
Future<List<Game>> favoriteGamesSorted(
  Ref ref,
) async {
  final games = await ref.watch(gamesByFavoritesProvider.future);

  final sorter = await ref.watch(favoriteGamesSorterProvider.future);

  return SorterUtils.sortGames(games, sorter);
}

@riverpod
Future<List<Game>> gamesWithNotesSorted(
  Ref ref,
) async {
  final games = await ref.watch(gamesWithNotesProvider.future);

  final sorter = await ref.watch(gamesWithNotesSorterProvider.future);

  return SorterUtils.sortGames(games, sorter);
}
