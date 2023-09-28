import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/charts/default_bar_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_pie_chart.dart';
import 'package:pile_of_shame/widgets/charts/legend.dart';

class Analytics extends ConsumerStatefulWidget {
  const Analytics({
    super.key,
    required this.legend,
    required this.gameCount,
    required this.price,
    required this.averagePrice,
  });

  final List<ChartData> legend;
  final AsyncValue<List<ChartData>> gameCount;
  final AsyncValue<List<ChartData>> price;
  final AsyncValue<List<ChartData>> averagePrice;

  @override
  ConsumerState<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends ConsumerState<Analytics> {
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
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    return ListView(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPaddingX,
            vertical: 8.0,
          ),
          child: Legend(
            onChangeSelection: handleSectionChange,
            data: widget.legend
                .map((e) => e.copyWith(isSelected: e.title == highlightedLabel))
                .toList(),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: widget.price.maybeWhen(
                orElse: () {
                  return const SizedBox();
                },
                data: (data) {
                  return SizedBox(
                    width: 350,
                    child: DefaultBarChart(
                      title: AppLocalizations.of(context)!.price,
                      onTapSection: handleSectionChange,
                      data: data
                          .map(
                            (e) => e.copyWith(
                              isSelected: highlightedLabel == e.title,
                            ),
                          )
                          .toList(),
                      formatData: (data) => currencyFormatter.format(data),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: widget.averagePrice.maybeWhen(
                orElse: () {
                  return const SizedBox();
                },
                data: (data) {
                  return SizedBox(
                    width: 350,
                    child: DefaultBarChart(
                      title: AppLocalizations.of(context)!.averagePrice,
                      onTapSection: handleSectionChange,
                      data: data
                          .map(
                            (e) => e.copyWith(
                              isSelected: highlightedLabel == e.title,
                            ),
                          )
                          .toList(),
                      formatData: (data) => currencyFormatter.format(data),
                      computeSum: (data) =>
                          data.fold(
                            0.0,
                            (previousValue, element) =>
                                element.value + previousValue,
                          ) /
                          data.length,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: widget.gameCount.maybeWhen(
                orElse: () {
                  return const SizedBox();
                },
                data: (data) {
                  return SizedBox(
                    width: 350,
                    child: DefaultPieChart(
                      title: AppLocalizations.of(context)!.gameCount,
                      onTapSection: handleSectionChange,
                      data: data
                          .map(
                            (e) => e.copyWith(
                              isSelected: highlightedLabel == e.title,
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
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

class AnalyticsSkeleton extends StatelessWidget {
  const AnalyticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
