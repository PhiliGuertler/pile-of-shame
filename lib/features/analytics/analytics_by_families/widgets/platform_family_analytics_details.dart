import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/utils/game_data.dart';
import 'package:pile_of_shame/utils/hardware_data.dart';
import 'package:pile_of_shame/widgets/charts/default_bar_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_comparison_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_pie_chart.dart';
import 'package:pile_of_shame/widgets/charts/highlightable_charts.dart';
import 'package:pile_of_shame/widgets/charts/legend.dart';
import 'package:pile_of_shame/widgets/responsiveness/responsive_wrap.dart';

class SliverPlatformFamilyAnalyticsDetails extends ConsumerWidget {
  const SliverPlatformFamilyAnalyticsDetails({
    super.key,
    required this.games,
    required this.hardware,
    this.hasFamilyDistributionChart = false,
  });

  final List<Game> games;
  final List<VideoGameHardware> hardware;
  final bool hasFamilyDistributionChart;

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

    final HardwareData hardwareData = HardwareData(
      hardware: hardware,
      l10n: l10n,
      currencyFormatter: currencyFormatter,
    );

    final completedData = gameData.toCompletedData();
    final ageRatingData = gameData.toAgeRatingData();

    return SliverList.list(
      children: [
        ResponsiveWrap(
          children: [
            if (gameData.hasData && hardwareData.hasData)
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.gamesVsHardware,
                      style: textTheme.titleLarge,
                    ),
                    Text(
                      currencyFormatter.format(
                        gameData.toTotalPrice() + hardwareData.toTotalPrice(),
                      ),
                    ),
                  ],
                ),
                subtitle: DefaultComparisonChart(
                  left: gameData.toTotalPrice(),
                  leftText:
                      "${currencyFormatter.format(gameData.toTotalPrice())} ${l10n.games}",
                  right: hardwareData.toTotalPrice(),
                  rightText:
                      "${currencyFormatter.format(hardwareData.toTotalPrice())} ${l10n.hardware}",
                  animationDelay: 200.ms,
                ),
              ),
            if (gameData.hasData)
              Padding(
                padding: const EdgeInsets.only(
                  left: defaultPaddingX,
                  right: defaultPaddingX,
                  top: defaultPaddingX,
                ),
                child: Text(
                  l10n.analyticsGames,
                  style: textTheme.headlineMedium,
                ),
              ),
            if (gameData.hasData)
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.priceDistribution,
                      style: textTheme.titleLarge,
                    ),
                    Text(currencyFormatter.format(gameData.toTotalPrice())),
                  ],
                ),
                subtitle: DefaultComparisonChart(
                  left: gameData.toTotalBasePrice(),
                  leftText:
                      "${currencyFormatter.format(gameData.toTotalBasePrice())} ${l10n.games}",
                  right: gameData.toTotalDLCPrice(),
                  rightText:
                      "${currencyFormatter.format(gameData.toTotalDLCPrice())} ${l10n.dlcs}",
                  animationDelay: 100.ms,
                ),
              ),
            if (gameData.hasData)
              ListTile(
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
                  animationDelay: 200.ms,
                ),
              ),
            if (gameData.hasData)
              ListTile(
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
                  animationDelay: 300.ms,
                ),
              ),
            if (gameData.hasData)
              ListTile(
                title: Text(
                  l10n.completionRate,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightablePieChart(
                    data: completedData,
                    formatData: (data) => l10n.nGames(data.toInt()),
                    formatTotalData: (totalData) => percentFormatter
                        .format(gameData.toCompletedPercentage()),
                    animationDelay: 400.ms,
                  ),
                ),
              ),
            if (gameData.hasData)
              ListTile(
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
                    animationDelay: 500.ms,
                  ),
                ),
              ),
            if (gameData.hasData)
              ListTile(
                title: Text(
                  l10n.ageRating,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightablePieChart(
                    data: ageRatingData,
                    formatData: (data) => l10n.nGames(data.toInt()),
                    formatTotalData: (totalData) =>
                        "${l10n.average}:\n${numberFormatter.format(gameData.toAverageAgeRating())}",
                    animationDelay: 600.ms,
                  ),
                ),
              ),
            if (gameData.hasData)
              ListTile(
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
                    animationDelay: 700.ms,
                  ),
                ),
              ),
            if (gameData.hasData)
              ListTile(
                title: Text(
                  l10n.platformDistribution,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightableBarChart(
                    data: gameData.toPlatformDistribution(),
                    formatData: (data) => l10n.nGames(data.toInt()),
                    animationDelay: 800.ms,
                  ),
                ),
              ),
            if (gameData.hasData)
              ListTile(
                title: Text(
                  l10n.priceDistributionByPlatform,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightableBarChart(
                    data: gameData.toPlatformPriceDistribution(),
                    formatData: (data) => currencyFormatter.format(data),
                    animationDelay: 900.ms,
                  ),
                ),
              ),
            if (gameData.hasData && hasFamilyDistributionChart)
              ListTile(
                title: Text(
                  l10n.priceDistributionByPlatformFamily,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightableBarChart(
                    data: gameData.toPlatformFamilyPriceDistribution(),
                    formatData: (data) => currencyFormatter.format(data),
                    animationDelay: 1000.ms,
                  ),
                ),
              ),
            if (hardwareData.hasData)
              Padding(
                padding: const EdgeInsets.only(
                  left: defaultPaddingX,
                  right: defaultPaddingX,
                  top: defaultPaddingX,
                ),
                child: Text(
                  l10n.hardwareAnalytics,
                  style: textTheme.headlineMedium,
                ),
              ),
            if (hardwareData.hasData)
              ListTile(
                title: Text(
                  l10n.averagePrice,
                  style: textTheme.titleLarge,
                ),
                subtitle: DefaultComparisonChart(
                  left: hardwareData.toAveragePrice(),
                  leftText:
                      "${currencyFormatter.format(hardwareData.toAveragePrice())} ${l10n.average}",
                  right: hardwareData.toMedianPrice(),
                  rightText:
                      "${currencyFormatter.format(hardwareData.toMedianPrice())} ${l10n.median}",
                  animationDelay: 300.ms,
                ),
              ),
            if (hardwareData.hasData)
              ListTile(
                title: Text(
                  l10n.priceDistribution,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightableCompactBarChart(
                    data: hardwareData.toPriceDistribution(
                      50.0,
                    ),
                    formatData: (data) => l10n.nHardware(data.toInt()),
                    animationDelay: 700.ms,
                  ),
                ),
              ),
            if (hardwareData.hasData)
              ListTile(
                title: Text(
                  l10n.platformDistribution,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightableBarChart(
                    data: hardwareData.toPlatformDistribution(),
                    formatData: (data) => l10n.nHardware(data.toInt()),
                    animationDelay: 800.ms,
                  ),
                ),
              ),
            if (hardwareData.hasData)
              ListTile(
                title: Text(
                  l10n.priceDistributionByPlatform,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightableBarChart(
                    data: hardwareData.toPlatformPriceDistribution(),
                    formatData: (data) => currencyFormatter.format(data),
                    animationDelay: 900.ms,
                  ),
                ),
              ),
            if (hardwareData.hasData && hasFamilyDistributionChart)
              ListTile(
                title: Text(
                  l10n.priceDistributionByPlatformFamily,
                  style: textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightableBarChart(
                    data: hardwareData.toPlatformFamilyPriceDistribution(),
                    formatData: (data) => currencyFormatter.format(data),
                    animationDelay: 1000.ms,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}

class SliverAnalyticsDetailsSkeleton extends StatelessWidget {
  const SliverAnalyticsDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: const [
        SizedBox(
          height: 16.0,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: defaultPaddingX, vertical: 8.0),
          child: LegendSkeleton(),
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: SizedBox(
                width: 350,
                child: DefaultBarChartSkeleton(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: SizedBox(
                width: 350,
                child: DefaultBarChartSkeleton(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: SizedBox(
                width: 350,
                child: DefaultPieChartSkeleton(),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
