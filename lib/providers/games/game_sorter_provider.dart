import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_sorter_provider.g.dart';

@riverpod
class SortGames extends _$SortGames {
  @override
  GameSorting build() {
    return const GameSorting();
  }

  void setSorting(GameSorting sorting) {
    state = sorting;
  }
}

@riverpod
List<Game> applyGameSorting(ApplyGameSortingRef ref, List<Game> games) {
  final sorting = ref.watch(sortGamesProvider);

  List<Game> result = List.from(games);

  result.sort(
    (a, b) => sorting.sortStrategy.sorter.compareGames(
      a,
      b,
      sorting.isAscending,
    ),
  );

  return result;
}
