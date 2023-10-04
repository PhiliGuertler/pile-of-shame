import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/utils/pair.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

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

  List<ChartData> toAgeRatingData() {
    final List<Pair<USK, int>> ageRatings = [
      for (var i = 0; i < USK.values.length; ++i) Pair(USK.values[i], 0),
    ];

    for (final game in games) {
      ageRatings[game.usk.index].second++;
    }

    final List<ChartData> result = [];
    for (var i = 0; i < USK.values.length; ++i) {
      final usk = ageRatings[i].first;
      final count = ageRatings[i].second;
      result.add(
        ChartData(
          title: usk.toRatedString(l10n),
          value: count.toDouble(),
          color: usk.toBackgroundColor(),
          isSelected: highlight == usk.toRatedString(l10n),
          alternativeTitle: USKLogo(
            ageRestriction: usk,
          ),
        ),
      );
    }

    result.removeWhere((element) => element.value < 0.01);

    return result;
  }

  List<ChartData> toPriceDistribution(double interval) {
    assert(interval > 0.0);

    final List<Pair<double, int>> priceDistribution = [];

    int processedGames = 0;
    double priceCap = interval;

    while (processedGames < games.length) {
      int matchingGames = games.fold(
        0,
        (previousValue, element) =>
            element.fullPrice() < priceCap ? previousValue + 1 : previousValue,
      );
      matchingGames -= processedGames;
      priceDistribution.add(Pair(priceCap, matchingGames));

      processedGames += matchingGames;
      priceCap += interval;
    }

    return priceDistribution
        .map(
          (e) => ChartData(
            title: "",
            value: e.second.toDouble(),
            secondaryValue: e.first,
          ),
        )
        .toList();
  }

  int toGameCount() {
    return games.length;
  }

  int toDLCCount() {
    return games.fold(
      0,
      (previousValue, element) => element.dlcs.length + previousValue,
    );
  }

  double toTotalPrice() {
    return games.fold(
      0.0,
      (previousValue, element) => element.fullPrice() + previousValue,
    );
  }

  double toTotalBasePrice() {
    return games.fold(
      0.0,
      (previousValue, element) => element.price + previousValue,
    );
  }

  double toTotalDLCPrice() {
    return games.fold(
      0.0,
      (previousValue, element) =>
          element.dlcs.fold(
            0.0,
            (previousValue, element) => element.price + previousValue,
          ) +
          previousValue,
    );
  }

  double toAveragePrice() {
    return toTotalPrice() / toGameCount();
  }

  double toMedianPrice() {
    if (games.isEmpty) {
      return 0.0;
    }
    final List<Game> sortedGames = List.from(games);
    sortedGames.sort((a, b) => a.fullPrice().compareTo(b.fullPrice()));

    return sortedGames[sortedGames.length ~/ 2].fullPrice();
  }
}
