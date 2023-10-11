import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/utils/game_data.dart';
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
    this.hasFamilyDistributionChart = false,
  });

  final List<Game> games;
  final bool hasFamilyDistributionChart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final percentFormatter = ref.watch(percentFormatProvider(context));
    final numberFormatter = ref.watch(numberFormatProvider(context));

    final GameData data = GameData(
      games: games,
      l10n: l10n,
      currencyFormatter: currencyFormatter,
    );

    final completedData = data.toCompletedData();
    final ageRatingData = data.toAgeRatingData();

    return SliverList.list(
      children: [
        ResponsiveWrap(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.priceDistribution,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(currencyFormatter.format(data.toTotalPrice())),
                ],
              ),
              subtitle: DefaultComparisonChart(
                left: data.toTotalBasePrice(),
                leftText:
                    "${currencyFormatter.format(data.toTotalBasePrice())} ${l10n.games}",
                right: data.toTotalDLCPrice(),
                rightText:
                    "${currencyFormatter.format(data.toTotalDLCPrice())} ${l10n.dlcs}",
                animationDelay: 100.ms,
              ),
            ),
            ListTile(
              title: Text(
                l10n.gameAndDLCAmount,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: DefaultComparisonChart(
                left: data.toGameCount().toDouble(),
                leftText: l10n.nGames(data.toGameCount()),
                right: data.toDLCCount().toDouble(),
                rightText: l10n.nDLCs(data.toDLCCount()),
                formatValue: (value) => value.toStringAsFixed(0),
                animationDelay: 200.ms,
              ),
            ),
            ListTile(
              title: Text(
                l10n.averagePrice,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: DefaultComparisonChart(
                left: data.toAveragePrice(),
                leftText:
                    "${currencyFormatter.format(data.toAveragePrice())} ${l10n.average}",
                right: data.toMedianPrice(),
                rightText:
                    "${currencyFormatter.format(data.toMedianPrice())} ${l10n.median}",
                animationDelay: 300.ms,
              ),
            ),
            ListTile(
              title: Text(
                l10n.completionRate,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: HighlightablePieChart(
                  data: completedData,
                  formatData: (data) => l10n.nGames(data.toInt()),
                  formatTotalData: (totalData) =>
                      percentFormatter.format(data.toCompletedPercentage()),
                  animationDelay: 400.ms,
                ),
              ),
            ),
            ListTile(
              title: Text(
                l10n.status,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: HighlightablePieChart(
                  data: data.toPlayStatusData(),
                  formatData: (data) => l10n.nGames(data.toInt()),
                  formatTotalData: (totalData) => "",
                  animationDelay: 500.ms,
                ),
              ),
            ),
            ListTile(
              title: Text(
                l10n.ageRating,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: HighlightablePieChart(
                  data: ageRatingData,
                  formatData: (data) => l10n.nGames(data.toInt()),
                  formatTotalData: (totalData) =>
                      "${l10n.average}:\n${numberFormatter.format(data.toAverageAgeRating())}",
                  animationDelay: 600.ms,
                ),
              ),
            ),
            ListTile(
              title: Text(
                l10n.priceDistribution,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: HighlightableCompactBarChart(
                  data: data.toPriceDistribution(
                    5.0,
                  ),
                  formatData: (data) => l10n.nGames(data.toInt()),
                  animationDelay: 700.ms,
                ),
              ),
            ),
            ListTile(
              title: Text(
                l10n.platformDistribution,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: HighlightableBarChart(
                  data: data.toPlatformDistribution(),
                  formatData: (data) => l10n.nGames(data.toInt()),
                  animationDelay: 800.ms,
                ),
              ),
            ),
            ListTile(
              title: Text(
                l10n.priceDistributionByPlatform,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: HighlightableBarChart(
                  data: data.toPlatformPriceDistribution(),
                  formatData: (data) => currencyFormatter.format(data),
                  animationDelay: 900.ms,
                ),
              ),
            ),
            if (hasFamilyDistributionChart)
              ListTile(
                title: Text(
                  l10n.priceDistributionByPlatformFamily,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: HighlightableBarChart(
                    data: data.toPlatformFamilyPriceDistribution(),
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
