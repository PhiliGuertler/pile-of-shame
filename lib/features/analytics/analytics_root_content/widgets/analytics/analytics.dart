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
  });

  final List<ChartData> legend;
  final AsyncValue<List<ChartData>> gameCount;
  final AsyncValue<List<ChartData>> price;

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
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX, vertical: 8.0),
          child: Legend(
            onChangeSelection: handleSectionChange,
            data: widget.legend
                .map((e) => e.copyWith(isSelected: e.title == highlightedLabel))
                .toList(),
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
              return DefaultPieChart(
                title: AppLocalizations.of(context)!.gameCount,
                onTapSection: handleSectionChange,
                data: data
                    .map((e) =>
                        e.copyWith(isSelected: highlightedLabel == e.title))
                    .toList(),
              );
            },
          ),
        ),
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
              return DefaultBarChart(
                title: AppLocalizations.of(context)!.price,
                onTapSection: handleSectionChange,
                data: data
                    .map((e) =>
                        e.copyWith(isSelected: highlightedLabel == e.title))
                    .toList(),
                formatData: (data) => currencyFormatter.format(data),
              );
            },
          ),
        ),
      ],
    );
  }
}