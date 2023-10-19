import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/game_and_hardware_data.dart';
import 'package:pile_of_shame/utils/game_data.dart';
import 'package:pile_of_shame/utils/hardware_data.dart';
import 'package:pile_of_shame/widgets/charts/default_comparison_chart.dart';
import 'package:pile_of_shame/widgets/charts/highlightable_charts.dart';
import 'package:pile_of_shame/widgets/slide_expandable.dart';

class GamesAndHardwareAnalytics extends ConsumerWidget {
  const GamesAndHardwareAnalytics({
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final currencyFormatter = ref.watch(currencyFormatProvider(context));

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
    final GameAndHardwareData gamesAndHardwareData = GameAndHardwareData(
      games: games,
      hardware: hardware,
      l10n: l10n,
      currencyFormatter: currencyFormatter,
    );

    const chartPadding =
        EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0);

    return SlideExpandable(
      imagePath: ImageAssets.pieChart.value,
      title: Text(
        l10n.miscAnalytics,
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
            animationDelay: 50.ms,
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
                data: gamesAndHardwareData.toPlatformPriceDistribution(),
                computeSum: (data) => data.fold(
                  0.0,
                  (previousValue, element) =>
                      previousValue +
                      element.value +
                      (element.secondaryValue ?? 0.0),
                ),
                formatData: (data, [isPrimary]) =>
                    "${currencyFormatter.format(data)}${isPrimary == null ? "" : isPrimary ? " ${l10n.games}" : " ${l10n.hardware}"}",
                animationDelay: 400.ms,
              ),
            ),
          ),
        if (hasFamilyDistributionChart)
          ListTile(
            contentPadding: chartPadding,
            title: Text(
              l10n.platformDistribution,
              style: textTheme.titleLarge,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: HighlightableBarChart(
                data: gamesAndHardwareData.toPlatformFamilyPriceDistribution(),
                computeSum: (data) => data.fold(
                  0.0,
                  (previousValue, element) =>
                      previousValue +
                      element.value +
                      (element.secondaryValue ?? 0.0),
                ),
                formatData: (data, [isPrimary]) =>
                    "${currencyFormatter.format(data)}${isPrimary == null ? "" : isPrimary ? " ${l10n.games}" : " ${l10n.hardware}"}",
                animationDelay: 400.ms,
              ),
            ),
          ),
      ],
    );
  }
}
