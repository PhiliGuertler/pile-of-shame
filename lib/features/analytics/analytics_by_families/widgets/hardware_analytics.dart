import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/hardware_data.dart';
import 'package:pile_of_shame/widgets/charts/default_comparison_chart.dart';
import 'package:pile_of_shame/widgets/charts/highlightable_charts.dart';
import 'package:pile_of_shame/widgets/slide_expandable.dart';

class HardwareAnalytics extends ConsumerWidget {
  const HardwareAnalytics({
    super.key,
    required this.hardware,
    this.hasFamilyDistributionChart = false,
    this.hasPlatformDistributionCharts = false,
  });

  final List<VideoGameHardware> hardware;
  final bool hasFamilyDistributionChart;
  final bool hasPlatformDistributionCharts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    final HardwareData hardwareData = HardwareData(
      hardware: hardware,
      l10n: l10n,
      currencyFormatter: currencyFormatter,
    );

    const chartPadding =
        EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0);

    return SlideExpandable(
      imagePath: ImageAssets.pc.value,
      title: Text(
        l10n.hardwareAnalytics,
      ),
      subtitle: Container(),
      trailing: Container(),
      children: [
        ListTile(
          contentPadding: chartPadding,
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
            animationDelay: 550.ms,
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
              data: hardwareData.toPriceDistribution(
                50.0,
              ),
              formatData: (data) => l10n.nHardware(data.toInt()),
              animationDelay: 600.ms,
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
                data: hardwareData.toPlatformDistribution(),
                formatData: (data, [isPrimary]) => l10n.nHardware(data.toInt()),
                animationDelay: 650.ms,
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
                data: hardwareData.toPlatformPriceDistribution(),
                formatData: (data, [isPrimary]) =>
                    currencyFormatter.format(data),
                animationDelay: 700.ms,
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
                data: hardwareData.toPlatformFamilyPriceDistribution(),
                formatData: (data, [isPrimary]) =>
                    currencyFormatter.format(data),
                animationDelay: 750.ms,
              ),
            ),
          ),
      ],
    );
  }
}
