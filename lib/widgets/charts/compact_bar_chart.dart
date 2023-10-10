import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/utils/color_utils.dart';

class CompactBarChart extends StatelessWidget {
  static String defaultFormatData(double data) {
    return (data == data.roundToDouble() ? data.toInt() : data).toString();
  }

  static double defaultComputeSum(List<ChartData> data) {
    return data.fold(
      0.0,
      (previousValue, element) => previousValue + element.value,
    );
  }

  final List<ChartData> data;
  final String Function(double data) formatData;
  final void Function(String? title)? onTapSection;
  final bool showBackground;
  final Duration animationDelay;

  const CompactBarChart({
    super.key,
    required this.data,
    this.formatData = defaultFormatData,
    this.showBackground = true,
    this.onTapSection,
    this.animationDelay = Duration.zero,
  });

  List<BarChartGroupData> generateChartData(
    Color backgroundColor,
    double maxWidth,
  ) {
    final List<BarChartGroupData> sections = [];
    final maxData = data.fold(
      0.0,
      (previousValue, element) =>
          element.value > previousValue ? element.value : previousValue,
    );
    final hasSelection = data.fold(
      false,
      (previousValue, element) => element.isSelected || previousValue,
    );

    final barWidth = maxWidth / (data.length + (hasSelection ? 2 : 0));
    final selectedBarWidth = 3 * barWidth;

    for (var i = 0; i < data.length; ++i) {
      final section = data[i];
      Color color = section.color ?? ColorUtils.stringToColor(section.title);
      HSLColor hsl = HSLColor.fromColor(color);
      hsl = hsl.withLightness(
        section.isSelected ? 0.5 : (i / data.length) * 0.2 + 0.4,
      );
      hsl = hsl.withSaturation(
        section.isSelected
            ? (hsl.saturation + 0.5).clamp(0.0, 1.0)
            : hsl.saturation,
      );
      hsl = hsl.withHue(
        section.isSelected
            ? ((hsl.hue + 180.0) % 360.0).clamp(0.0, 360.0)
            : hsl.hue,
      );
      color = hsl.toColor();
      sections.add(
        BarChartGroupData(
          x: i,
          barsSpace: 0,
          barRods: [
            BarChartRodData(
              toY: max(section.value, 0.02),
              color: color,
              width: section.isSelected ? selectedBarWidth : barWidth,
              borderRadius: BorderRadius.zero,
              backDrawRodData: showBackground
                  ? BackgroundBarChartRodData(
                      color: backgroundColor
                          .withOpacity(section.isSelected ? 0.2 : 0.1),
                      fromY: 0,
                      toY: maxData,
                      show: true,
                    )
                  : null,
            ),
          ],
        ),
      );
    }
    final List<BarChartGroupData> initialSections = [];
    final average = data.fold(
          0.0,
          (previousValue, element) => previousValue + element.value,
        ) /
        data.length;
    for (int i = 0; i < sections.length; ++i) {
      final List<BarChartRodData> rods = List.from(sections[i].barRods);
      for (int k = 0; k < rods.length; ++k) {
        rods[k] = rods[k].copyWith(toY: average);
      }
      initialSections.add(sections[i].copyWith(barRods: rods));
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    String totalLabel = "";
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
        SizedBox(
          height: 250.0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chartData = generateChartData(
                Theme.of(context).colorScheme.primaryContainer,
                constraints.maxWidth,
              );
              return BarChart(
                BarChartData(
                  minY: 0.0,
                  maxY: data.fold<double>(
                    0.0,
                    (previousValue, element) => element.value > previousValue
                        ? element.value
                        : previousValue,
                  ),
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                    bottomTitles: AxisTitles(),
                    leftTitles: AxisTitles(),
                  ),
                  barGroups: chartData,
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
                          final sectionName =
                              index >= 0 ? data[index].title : null;
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
                swapAnimationCurve: Curves.easeInOutBack,
              );
            },
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
    ).animate().scaleY(
          begin: 0.0,
          end: 1.0,
          curve: Curves.easeOutBack,
          duration: 500.ms,
          delay: animationDelay,
        );
  }
}
