import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/providers/mixins/persistable_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_sorter_provider.g.dart';

@Riverpod(keepAlive: true)
class SortGames extends _$SortGames with Persistable {
  static const String storageKey = "sorter";

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
FutureOr<List<Game>> applyGameSorting(
  ApplyGameSortingRef ref,
  List<Game> games,
) async {
  final sorting = await ref.watch(sortGamesProvider.future);

  final List<Game> result = List.from(games);

  result.sort(
    (a, b) => sorting.sortStrategy.sorter.compareGames(
      a,
      b,
      sorting.isAscending,
    ),
  );

  return result;
}
