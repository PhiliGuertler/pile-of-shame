import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/widgets/game_analytics.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/widgets/games_and_hardware_analytics.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/widgets/hardware_analytics.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/charts/default_bar_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_pie_chart.dart';
import 'package:pile_of_shame/widgets/charts/legend.dart';

class SliverAnalyticsDetails extends StatelessWidget {
  const SliverAnalyticsDetails({
    super.key,
    required this.games,
    required this.hardware,
    this.hasFamilyDistributionChart = false,
    this.hasPlatformDistributionCharts = false,
  });

  final List<Game> games;
  final List<VideoGameHardware> hardware;
  final bool hasFamilyDistributionChart;
  final bool hasPlatformDistributionCharts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return SliverList.list(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: defaultPaddingX,
            right: defaultPaddingX,
            bottom: 8.0,
            top: 16.0,
          ),
          child: Text(
            l10n.analytics,
            style: textTheme.headlineMedium,
          ),
        ),
        if (games.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
            ),
            child: GameAnalytics(
              games: games,
              hasFamilyDistributionChart: hasFamilyDistributionChart,
              hasPlatformDistributionCharts: hasPlatformDistributionCharts,
            ),
          ),
        if (games.isNotEmpty && hardware.isNotEmpty)
          const SizedBox(height: 32.0),
        if (hardware.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
            ),
            child: HardwareAnalytics(
              hardware: hardware,
              hasFamilyDistributionChart: hasFamilyDistributionChart,
              hasPlatformDistributionCharts: hasPlatformDistributionCharts,
            ),
          ),
        if (games.isNotEmpty && hardware.isNotEmpty)
          const SizedBox(height: 32.0),
        if (games.isNotEmpty && hardware.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
            ),
            child: GamesAndHardwareAnalytics(
              games: games,
              hardware: hardware,
              hasFamilyDistributionChart: hasFamilyDistributionChart,
              hasPlatformDistributionCharts: hasPlatformDistributionCharts,
            ),
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
