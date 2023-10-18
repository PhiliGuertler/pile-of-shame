import 'package:pile_of_shame/features/games/games_by_playstatus/models/games_by_playstatus_models.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/providers/mixins/persistable_mixin.dart';
import 'package:pile_of_shame/utils/sorter_utils.dart';
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

@riverpod
Future<GameSorting> gameSortingByPlayStatus(
  GameSortingByPlayStatusRef ref,
  PlayStatus status,
) async {
  final sorters = await ref.watch(gamesByPlayStatusSorterProvider.future);

  return sorters[status]!;
}

@riverpod
Future<List<Game>> gamesByPlayStatusesSorted(
  GamesByPlayStatusesSortedRef ref,
  List<PlayStatus> statuses,
) async {
  assert(statuses.isNotEmpty);

  final games = await ref.watch(gamesByPlayStatusProvider(statuses).future);

  final sorter =
      await ref.watch(gameSortingByPlayStatusProvider(statuses.first).future);

  return SorterUtils.sortGames(games, sorter);
}
