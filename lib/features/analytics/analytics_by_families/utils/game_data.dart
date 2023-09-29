import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game.dart';

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
          title: "Durchgespielt",
          value: completedGamesCount.toDouble(),
          color: Colors.green,
          isSelected: highlight == "Durchgespielt",
        ),
      if (completedGamesCount < games.length)
        ChartData(
          title: "Nicht Durchgespielt",
          value: (games.length - completedGamesCount).toDouble(),
          color: Colors.red,
          isSelected: highlight == "Nicht Durchgespielt",
        ),
    ];
  }
}
