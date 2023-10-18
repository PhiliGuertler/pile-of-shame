import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/hardware_sorting.dart';

class SorterUtils {
  const SorterUtils._();

  static List<Game> sortGames(List<Game> games, GameSorting sorting) {
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

  static List<VideoGameHardware> sortHardware(
    List<VideoGameHardware> hardware,
    HardwareSorting sorting,
  ) {
    final List<VideoGameHardware> result = List.from(hardware);

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
