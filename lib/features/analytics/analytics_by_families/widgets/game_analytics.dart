import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/game_data.dart';
import 'package:pile_of_shame/widgets/charts/default_comparison_chart.dart';
import 'package:pile_of_shame/widgets/charts/highlightable_charts.dart';
import 'package:pile_of_shame/widgets/slide_expandable.dart';

class GameAnalytics extends ConsumerWidget {
  const GameAnalytics({
    super.key,
    required this.games,
    this.hasFamilyDistributionChart = false,
    this.hasPlatformDistributionCharts = false,
  });

  final List<Game> games;
  final bool hasFamilyDistributionChart;
  final bool hasPlatformDistributionCharts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final percentFormatter = ref.watch(percentFormatProvider(context));
    final numberFormatter = ref.watch(numberFormatProvider(context));

    final GameData gameData = GameData(
      games: games,
      l10n: l10n,
      currencyFormatter: currencyFormatter,
    );

    const chartPadding =
        EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0);

    return SlideExpandable(
      key: const ValueKey("game_analytics"),
      imageAsset: ImageAssets.controllerUnknown,
      title: Text(
        l10n.analyticsGames,
      ),
      subtitle: Container(),
      trailing: Container(),
      children: [
        ListTile(
          contentPadding: chartPadding,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.priceDistribution,
                style: textTheme.titleLarge,
              ),
              Text(
                currencyFormatter.format(gameData.toTotalPrice()),
              ),
            ],
          ),
          subtitle: DefaultComparisonChart(
            left: gameData.toTotalBasePrice(),
            leftText:
                "${currencyFormatter.format(gameData.toTotalBasePrice())} ${l10n.games}",
            right: gameData.toTotalDLCPrice(),
            rightText:
                "${currencyFormatter.format(gameData.toTotalDLCPrice())} ${l10n.dlcs}",
            animationDelay: 50.ms,
          ),
        ),
        ListTile(
          contentPadding: chartPadding,
          title: Text(
            l10n.gameAndDLCAmount,
            style: textTheme.titleLarge,
          ),
          subtitle: DefaultComparisonChart(
            left: gameData.toGameCount().toDouble(),
            leftText: l10n.nGames(gameData.toGameCount()),
            right: gameData.toDLCCount().toDouble(),
            rightText: l10n.nDLCs(gameData.toDLCCount()),
            formatValue: (value) => value.toStringAsFixed(0),
            animationDelay: 100.ms,
          ),
        ),
        ListTile(
          contentPadding: chartPadding,
          title: Text(
            l10n.averagePrice,
            style: textTheme.titleLarge,
          ),
          subtitle: DefaultComparisonChart(
            left: gameData.toAveragePrice(),
            leftText:
                "${currencyFormatter.format(gameData.toAveragePrice())} ${l10n.average}",
            right: gameData.toMedianPrice(),
            rightText:
                "${currencyFormatter.format(gameData.toMedianPrice())} ${l10n.median}",
            animationDelay: 150.ms,
          ),
        ),
        ListTile(
          contentPadding: chartPadding,
          title: Text(
            l10n.completionRate,
            style: textTheme.titleLarge,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: HighlightablePieChart(
              data: gameData.toCompletedData(),
              formatData: (data) => l10n.nGames(data.toInt()),
              formatTotalData: (totalData) =>
                  percentFormatter.format(gameData.toCompletedPercentage()),
              animationDelay: 200.ms,
            ),
          ),
        ),
        ListTile(
          contentPadding: chartPadding,
          title: Text(
            l10n.status,
            style: textTheme.titleLarge,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: HighlightablePieChart(
              data: gameData.toPlayStatusData(),
              formatData: (data) => l10n.nGames(data.toInt()),
              formatTotalData: (totalData) => "",
              animationDelay: 250.ms,
            ),
          ),
        ),
        ListTile(
          contentPadding: chartPadding,
          title: Text(
            l10n.ageRating,
            style: textTheme.titleLarge,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: HighlightablePieChart(
              data: gameData.toAgeRatingData(),
              formatData: (data) => l10n.nGames(data.toInt()),
              formatTotalData: (totalData) =>
                  "${l10n.average}:\n${numberFormatter.format(gameData.toAverageAgeRating())}",
              animationDelay: 300.ms,
            ),
          ),
        ),
        ListTile(
          contentPadding: chartPadding,
          title: Text(
            l10n.priceDistribution,
            style: textTheme.titleLarge,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: HighlightableCompactBarChart(
              data: gameData.toPriceDistribution(
                5.0,
              ),
              formatData: (data) => l10n.nGames(data.toInt()),
              animationDelay: 350.ms,
            ),
          ),
        ),
        if (hasPlatformDistributionCharts)
          ListTile(
            contentPadding: chartPadding,
            title: Text(
              l10n.platformDistribution,
              style: textTheme.titleLarge,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: HighlightableBarChart(
                data: gameData.toPlatformDistribution(),
                formatData: (data, [isPrimary]) => l10n.nGames(data.toInt()),
                animationDelay: 400.ms,
              ),
            ),
          ),
        if (hasPlatformDistributionCharts)
          ListTile(
            contentPadding: chartPadding,
            title: Text(
              l10n.priceDistributionByPlatform,
              style: textTheme.titleLarge,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: HighlightableBarChart(
                data: gameData.toPlatformPriceDistribution(),
                formatData: (data, [isPrimary]) =>
                    currencyFormatter.format(data),
                animationDelay: 450.ms,
              ),
            ),
          ),
        if (hasFamilyDistributionChart)
          ListTile(
            contentPadding: chartPadding,
            title: Text(
              l10n.priceDistributionByPlatformFamily,
              style: textTheme.titleLarge,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: HighlightableBarChart(
                data: gameData.toPlatformFamilyPriceDistribution(),
                formatData: (data, [isPrimary]) =>
                    currencyFormatter.format(data),
                animationDelay: 500.ms,
              ),
            ),
          ),
      ],
    );
  }
}
