import 'package:pile_of_shame/features/analytics/analytics_by_families/models/price_span.dart';
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

  List<ChartData> toPriceAccumulation() {
    final List<double> prices = games.map((e) => e.fullPrice()).toList();
    prices.sort((a, b) => a.compareTo(b));

    final List<ChartData> result = [];
    for (int i = 0; i < prices.length; ++i) {
      final price = prices[i];
      result.add(
        ChartData(title: "", value: (i + 1).toDouble(), secondaryValue: price),
      );
    }
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

  PriceSpan toPriceSpanWithGifts() {
    final min = games.fold(
      double.infinity,
      (previousValue, element) => element.fullPrice() < previousValue
          ? element.fullPrice()
          : previousValue,
    );
    final max = games.fold(
      double.negativeInfinity,
      (previousValue, element) => element.fullPrice() > previousValue
          ? element.fullPrice()
          : previousValue,
    );
    final sum = games.fold(
      0.0,
      (previousValue, element) => element.fullPrice() + previousValue,
    );

    return PriceSpan(min: min, max: max, avg: sum / games.length);
  }

  PriceSpan toPriceSpanWithoutGifts() {
    final nonGiftedGames = games.where((element) => !element.wasGifted);

    final min = nonGiftedGames.fold(
      double.infinity,
      (previousValue, element) => element.fullPrice() < previousValue
          ? element.fullPrice()
          : previousValue,
    );
    final max = nonGiftedGames.fold(
      double.negativeInfinity,
      (previousValue, element) => element.fullPrice() > previousValue
          ? element.fullPrice()
          : previousValue,
    );
    final sum = nonGiftedGames.fold(
      0.0,
      (previousValue, element) => element.fullPrice() + previousValue,
    );

    return PriceSpan(min: min, max: max, avg: sum / nonGiftedGames.length);
  }

  PriceSpan toPriceMedianSpanWithGifts() {
    final prices = games.map((e) => e.fullPrice()).toList();
    prices.sort((a, b) => a.compareTo(b));

    final min = prices.fold(
      double.infinity,
      (previousValue, element) =>
          element < previousValue ? element : previousValue,
    );
    final max = prices.fold(
      double.negativeInfinity,
      (previousValue, element) =>
          element > previousValue ? element : previousValue,
    );
    final median = prices[prices.length ~/ 2];

    return PriceSpan(min: min, max: max, avg: median);
  }

  PriceSpan toPriceMedianSpanWithoutGifts() {
    final nonGiftedGames = games.where((element) => !element.wasGifted);
    final prices = nonGiftedGames.map((e) => e.fullPrice()).toList();
    prices.sort((a, b) => a.compareTo(b));

    final min = prices.fold(
      double.infinity,
      (previousValue, element) =>
          element < previousValue ? element : previousValue,
    );
    final max = prices.fold(
      double.negativeInfinity,
      (previousValue, element) =>
          element > previousValue ? element : previousValue,
    );
    final median = prices[prices.length ~/ 2];

    return PriceSpan(min: min, max: max, avg: median);
  }
}
