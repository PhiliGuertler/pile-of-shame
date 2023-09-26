import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/utils/color_utils.dart';

String defaultFormatData(double data) {
  return (data == data.roundToDouble() ? data.toInt() : data).toString();
}

class DefaultBarChart extends StatelessWidget {
  final List<ChartData> data;
  final String title;
  final String Function(double data) formatData;
  final void Function(String? title)? onTapSection;

  const DefaultBarChart({
    super.key,
    required this.data,
    required this.title,
    this.formatData = defaultFormatData,
    this.onTapSection,
  });

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> sections = [];
    for (var i = 0; i < data.length; ++i) {
      final section = data[i];
      final color = ColorUtils.stringToColor(section.title);
      sections.add(BarChartGroupData(
        x: i,
        barsSpace: 0,
        barRods: [
          BarChartRodData(
            toY: section.value,
            color: color,
            width: section.isSelected ? 25.0 : 15.0,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ],
      ));
    }

    final total = formatData(
      data.fold(0.0, (previousValue, element) => previousValue + element.value),
    );
    String totalLabel = AppLocalizations.of(context)!.totalN(total);
    try {
      final selected = data.singleWhere(
        (element) => element.isSelected,
      );
      totalLabel = "${selected.title}: ${formatData(selected.value)}";
    } catch (error) {
      // do nothing
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: 250.0,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              titlesData: const FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: sections,
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 8,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      formatData(rod.toY),
                      TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  if (event.isInterestedForInteractions &&
                      onTapSection != null &&
                      event.runtimeType == FlTapDownEvent) {
                    if (response != null && response.spot != null) {
                      final index = response.spot!.touchedBarGroupIndex;
                      final sectionName = index >= 0 ? data[index].title : null;
                      onTapSection!(sectionName);
                    } else {
                      onTapSection!(null);
                    }
                  }
                },
              ),
              gridData: const FlGridData(show: false),
            ),
            swapAnimationDuration: 250.ms,
            swapAnimationCurve: Curves.easeOutBack,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: Text(
            totalLabel,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
