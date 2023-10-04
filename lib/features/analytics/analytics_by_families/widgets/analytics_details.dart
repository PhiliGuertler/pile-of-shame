import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/utils/game_data.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/charts/default_bar_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_comparison_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_line_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_pie_chart.dart';
import 'package:pile_of_shame/widgets/charts/legend.dart';

class SliverAnalyticsDetails extends ConsumerStatefulWidget {
  const SliverAnalyticsDetails({
    super.key,
    required this.games,
  });

  final List<Game> games;

  @override
  ConsumerState<SliverAnalyticsDetails> createState() =>
      _SliverAnalyticsDetailsState();
}

class _SliverAnalyticsDetailsState
    extends ConsumerState<SliverAnalyticsDetails> {
  String? highlightedLabel;

  void handleSectionChange(String? selection) {
    if (highlightedLabel == selection) {
      setState(() {
        highlightedLabel = null;
      });
    } else {
      setState(() {
        highlightedLabel = selection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    final GameData data =
        GameData(games: widget.games, l10n: l10n, highlight: highlightedLabel);

    return SliverList.list(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.priceDistribution,
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
              ),
            ),
            ListTile(
              title: Text(
                l10n.gameAndDLCAmount,
              ),
              subtitle: DefaultComparisonChart(
                left: data.toGameCount().toDouble(),
                leftText: l10n.nGames(data.toGameCount()),
                right: data.toDLCCount().toDouble(),
                rightText: l10n.nDLCs(data.toDLCCount()),
                formatValue: (value) => value.toStringAsFixed(0),
              ),
            ),
            ListTile(
              title: Text(
                l10n.averagePrice,
              ),
              subtitle: DefaultComparisonChart(
                left: data.toAveragePrice(),
                leftText:
                    "${currencyFormatter.format(data.toAveragePrice())} ${l10n.average}",
                right: data.toMedianPrice(),
                rightText:
                    "${currencyFormatter.format(data.toMedianPrice())} ${l10n.median}",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 16.0,
              ),
              child: DefaultPieChart(
                data: data.toCompletedData(),
                title: l10n.completionRate,
                onTapSection: handleSectionChange,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 16.0,
              ),
              child: DefaultPieChart(
                data: data.toPlayStatusData(),
                title: l10n.status,
                onTapSection: handleSectionChange,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 16.0,
              ),
              child: DefaultPieChart(
                data: data.toAgeRatingData(),
                title: l10n.ageRating,
                onTapSection: handleSectionChange,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 16.0,
              ),
              child: DefaultLineChart(
                data: data.toPriceDistribution(10.0),
                interval: 15.0,
                title: l10n.priceDistribution,
                onTapSection: handleSectionChange,
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
