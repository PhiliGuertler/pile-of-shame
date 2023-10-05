import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_sorting.dart';

class GameSorterUtils {
  const GameSorterUtils();

  List<Game> sortGames(List<Game> games, GameSorting sorting) {
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
}
