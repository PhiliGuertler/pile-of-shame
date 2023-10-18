import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/utils/sorter_utils.dart';

class GameGrouperUtils {
  final AppLocalizations l10n;

  const GameGrouperUtils({required this.l10n});

  Map<String, List<Game>> groupGames(
    List<Game> games,
    GroupStrategy groupStrategy,
  ) {
    if (groupStrategy.grouper != null) {
      final grouper = groupStrategy.grouper!;
      final allValues = grouper.values();
      final Map<String, List<Game>> result = Map.fromEntries(
        allValues
            .map((e) => MapEntry(grouper.groupToLocaleString(l10n, e), [])),
      );
      for (final game in games) {
        for (final group in allValues) {
          if (grouper.matchesGroup(group, game)) {
            result[grouper.groupToLocaleString(l10n, group)]!.add(game);
          }
        }
      }
      result.removeWhere((key, value) => value.isEmpty);
      return result;
    } else {
      return {"": games};
    }
  }

  Map<String, List<Game>> groupAndSortGames(
    List<Game> games,
    GroupStrategy grouping,
    GameSorting sorting,
  ) {
    final sortedGames = SorterUtils.sortGames(games, sorting);

    return groupGames(sortedGames, grouping);
  }
}
