import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/game_data.dart';
import 'package:pile_of_shame/widgets/charts/default_comparison_chart.dart';
import 'package:pile_of_shame/widgets/charts/highlightable_charts.dart';

class SliverAnalyticsPlatformDetails extends ConsumerWidget {
  const SliverAnalyticsPlatformDetails({
    super.key,
    required this.games,
  });

  final List<Game> games;

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
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
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
                  formatTotalData: (totalData) {
                    try {
                      final completed = completedData.firstWhere(
                        (element) => element.title == l10n.completed,
                      );
                      final completedPercentage = completed.value /
                          completedData.fold(
                            0,
                            (previousValue, element) =>
                                element.value + previousValue,
                          );
                      return percentFormatter.format(completedPercentage);
                    } catch (error) {
                      return percentFormatter.format(0);
                    }
                  },
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
                  formatTotalData: (totalData) {
                    final ageSum = ageRatingData.fold(
                      0.0,
                      (previousValue, element) =>
                          element.value * element.secondaryValue!,
                    );
                    final elementCount = ageRatingData.fold(
                      0.0,
                      (previousValue, element) => element.value + previousValue,
                    );
                    return "${l10n.average}:\n${numberFormatter.format(ageSum / elementCount)}";
                  },
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
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
