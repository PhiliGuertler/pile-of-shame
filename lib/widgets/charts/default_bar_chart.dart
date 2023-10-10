import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/utils/color_utils.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';

class DefaultBarChart extends StatelessWidget {
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
  final double Function(List<ChartData> data) computeSum;
  final void Function(String? title)? onTapSection;
  final Duration animationDelay;

  const DefaultBarChart({
    super.key,
    required this.data,
    this.formatData = defaultFormatData,
    this.computeSum = defaultComputeSum,
    this.onTapSection,
    this.animationDelay = Duration.zero,
  });

  List<BarChartGroupData> generateChartData(
    Color backgroundColor,
  ) {
    final List<BarChartGroupData> sections = [];
    for (var i = 0; i < data.length; ++i) {
      final section = data[i];
      final color = section.color ?? ColorUtils.stringToColor(section.title);
      sections.add(
        BarChartGroupData(
          x: i,
          barsSpace: 0,
          barRods: [
            BarChartRodData(
              toY: section.value,
              color: color,
              width: section.isSelected ? 45.0 : 15.0,
              borderRadius: BorderRadius.circular(4.0),
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
    final total = formatData(
      computeSum(data),
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

    final chartData =
        generateChartData(Theme.of(context).colorScheme.primaryContainer);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 250.0,
          child: BarChart(
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
            swapAnimationCurve: Curves.easeInOutBack,
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

class DefaultBarChartSkeleton extends StatelessWidget {
  const DefaultBarChartSkeleton({super.key});

  Stream<List<BarChartGroupData>> randomChartSections(Color color) async* {
    final Random rand = Random();

    const maxData = 10.0;
    while (true) {
      final List<BarChartGroupData> result = [];
      for (int i = 0; i < 6; ++i) {
        final value = rand.nextDouble() * 8.0 + 2.0;
        result.add(
          BarChartGroupData(
            x: i,
            barsSpace: 0,
            barRods: [
              BarChartRodData(
                toY: value,
                color: color.withOpacity(rand.nextDouble() * 0.5 + 0.3),
                width: 15.0,
                borderRadius: BorderRadius.circular(4.0),
                backDrawRodData: BackgroundBarChartRodData(
                  color: color.withOpacity(0.1),
                  fromY: 0,
                  toY: maxData,
                  show: true,
                ),
              ),
            ],
          ),
        );
      }
      yield result;

      await Future.delayed(500.ms);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 250.0,
          child: StreamBuilder<List<BarChartGroupData>>(
            stream: randomChartSections(
              Theme.of(context).colorScheme.primaryContainer,
            ),
            builder: (context, snapshot) {
              return BarChart(
                BarChartData(
                  minY: 0.0,
                  maxY: 10.0,
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                    bottomTitles: AxisTitles(),
                  ),
                  barGroups: snapshot.data,
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  gridData: const FlGridData(show: false),
                ),
                swapAnimationDuration: 250.ms,
                swapAnimationCurve: Curves.easeInOutBack,
              );
            },
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: Skeleton.defaultAnimationDuration,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )
              .animate()
              .fadeIn(
                duration: Duration(
                  milliseconds:
                      (Skeleton.defaultAnimationDuration.inMilliseconds * 0.5)
                          .toInt(),
                ),
              ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: Center(
            child: SizedBox(
              width: 80.0,
              child: Skeleton(
                widthFactor: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
