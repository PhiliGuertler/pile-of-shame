import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/utils/color_utils.dart';

class CompactBarChart extends StatefulWidget {
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

  const CompactBarChart({
    super.key,
    required this.data,
    this.formatData = defaultFormatData,
    this.showBackground = true,
    this.onTapSection,
  });

  @override
  State<CompactBarChart> createState() => _CompactBarChartState();
}

class _CompactBarChartState extends State<CompactBarChart> {
  bool skipAnimation = false;

  Stream<List<BarChartGroupData>> generateChartData(
    Color backgroundColor,
    double maxWidth,
  ) async* {
    final List<BarChartGroupData> sections = [];
    final maxData = widget.data.fold(
      0.0,
      (previousValue, element) =>
          element.value > previousValue ? element.value : previousValue,
    );
    final hasSelection = widget.data.fold(
      false,
      (previousValue, element) => element.isSelected || previousValue,
    );

    final barWidth = maxWidth / (widget.data.length + (hasSelection ? 2 : 0));
    final selectedBarWidth = 3 * barWidth;

    for (var i = 0; i < widget.data.length; ++i) {
      final section = widget.data[i];
      Color color = section.color ?? ColorUtils.stringToColor(section.title);
      HSLColor hsl = HSLColor.fromColor(color);
      hsl = hsl.withLightness(
        section.isSelected ? 0.5 : (i / widget.data.length) * 0.2 + 0.4,
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
              backDrawRodData: widget.showBackground
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
    final average = widget.data.fold(
          0.0,
          (previousValue, element) => previousValue + element.value,
        ) /
        widget.data.length;
    for (int i = 0; i < sections.length; ++i) {
      final List<BarChartRodData> rods = List.from(sections[i].barRods);
      for (int k = 0; k < rods.length; ++k) {
        rods[k] = rods[k].copyWith(toY: average);
      }
      initialSections.add(sections[i].copyWith(barRods: rods));
    }
    if (!skipAnimation) {
      yield initialSections;
      await Future.delayed(200.ms);
      if (context.mounted) {
        setState(() {
          skipAnimation = true;
        });
      }
    }
    yield sections;
  }

  @override
  Widget build(BuildContext context) {
    String totalLabel = "";
    try {
      final selected = widget.data.singleWhere(
        (element) => element.isSelected,
      );
      totalLabel = "${selected.title}: ${widget.formatData(selected.value)}";
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
              return StreamBuilder<List<BarChartGroupData>>(
                stream: generateChartData(
                  Theme.of(context).colorScheme.primaryContainer,
                  constraints.maxWidth,
                ),
                builder: (context, snapshot) {
                  return BarChart(
                    BarChartData(
                      minY: 0.0,
                      maxY: widget.data.fold<double>(
                        0.0,
                        (previousValue, element) =>
                            element.value > previousValue
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
                      barGroups: snapshot.data,
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
                              widget.formatData(rod.toY),
                              TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        touchCallback: (event, response) {
                          if (event.isInterestedForInteractions &&
                              widget.onTapSection != null &&
                              event.runtimeType == FlTapDownEvent) {
                            if (response != null && response.spot != null) {
                              final index = response.spot!.touchedBarGroupIndex;
                              final sectionName =
                                  index >= 0 ? widget.data[index].title : null;
                              widget.onTapSection!(sectionName);
                            } else {
                              widget.onTapSection!(null);
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
    );
  }
}
