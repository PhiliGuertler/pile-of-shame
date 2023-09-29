import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/utils/pair.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';

class GameData {
  final List<Game> games;
  final AppLocalizations l10n;
  final String? highlight;

  const GameData({required this.games, required this.l10n, this.highlight});

  List<ChartData> toPlatformLegendData(
    String? highlightedLabel,
  ) {
    final Set<ChartData> result = {};
    for (final element in games) {
      final platformName = element.platform.localizedAbbreviation(l10n);

      result.add(
        ChartData(
          title: platformName,
          value: 0.0,
          isSelected: highlightedLabel == platformName,
        ),
      );
    }
    return result.toList();
  }

  List<ChartData> toCompletedData() {
    final completedGamesCount = games.fold(
      0,
      (previousValue, element) =>
          element.status.isCompleted ? previousValue + 1 : previousValue,
    );
    return [
      if (completedGamesCount > 0)
        ChartData(
          title: l10n.completed,
          value: completedGamesCount.toDouble(),
          color: PlayStatus.completed.backgroundColor,
          isSelected: highlight == l10n.completed,
          alternativeTitle: const PlayStatusIcon(
            playStatus: PlayStatus.completed,
          ),
        ),
      if (completedGamesCount < games.length)
        ChartData(
          title: l10n.incomplete,
          value: (games.length - completedGamesCount).toDouble(),
          color: PlayStatus.cancelled.backgroundColor,
          isSelected: highlight == l10n.incomplete,
          alternativeTitle: const PlayStatusIcon(
            playStatus: PlayStatus.cancelled,
          ),
        ),
    ];
  }

  List<ChartData> toPlayStatusData() {
    final List<Pair<PlayStatus, int>> statusCount = [
      for (var i = 0; i < PlayStatus.values.length; ++i)
        Pair(PlayStatus.values[i], 0),
    ];

    for (final game in games) {
      statusCount[game.status.index].second++;
    }

    // sort completed and not completed together
    statusCount.sort(
      (a, b) => a.first.isCompleted == b.first.isCompleted
          ? 0
          : a.first.isCompleted
              ? -1
              : 1,
    );

    final List<ChartData> result = [];
    for (var i = 0; i < PlayStatus.values.length; ++i) {
      final status = statusCount[i].first;
      final count = statusCount[i].second;
      result.add(
        ChartData(
          title: status.toLocaleString(l10n),
          value: count.toDouble(),
          color: status.backgroundColor,
          isSelected: highlight == status.toLocaleString(l10n),
          alternativeTitle: PlayStatusIcon(
            playStatus: status,
          ),
        ),
      );
    }

    result.removeWhere((element) => element.value < 0.01);

    return result;
  }
}
