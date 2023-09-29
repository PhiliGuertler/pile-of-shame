import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/utils/color_utils.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';

String defaultFormatData(double data) {
  return (data == data.roundToDouble() ? data.toInt() : data).toString();
}

class DefaultPieChart extends StatefulWidget {
  final List<ChartData> data;
  final String title;
  final String Function(double data) formatData;
  final void Function(String? title)? onTapSection;

  const DefaultPieChart({
    super.key,
    required this.data,
    required this.title,
    this.formatData = defaultFormatData,
    this.onTapSection,
  });

  @override
  State<DefaultPieChart> createState() => _DefaultPieChartState();
}

class _DefaultPieChartState extends State<DefaultPieChart> {
  bool skipAnimation = false;

  Stream<List<PieChartSectionData>> generateChartData() async* {
    final List<PieChartSectionData> sections = [];
    for (var i = 0; i < widget.data.length; ++i) {
      final section = widget.data[i];
      final color = section.color ?? ColorUtils.stringToColor(section.title);
      sections.add(
        PieChartSectionData(
          color: color,
          title: section.alternativeTitle != null
              ? ""
              : widget.formatData(section.value),
          value: section.value,
          titleStyle: TextStyle(
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          ),
          radius: section.isSelected ? 70.0 : 60.0,
          badgeWidget: section.alternativeTitle,
          badgePositionPercentageOffset: 0.95,
        ),
      );
    }
    final List<PieChartSectionData> initialSections = [];
    for (int i = 0; i < sections.length; ++i) {
      initialSections.add(sections[i].copyWith(value: 1.0));
    }
    if (!skipAnimation) {
      yield initialSections;
      await Future.delayed(200.ms);
      setState(() {
        skipAnimation = true;
      });
    }
    yield sections;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.formatData(
      widget.data
          .fold(0.0, (previousValue, element) => previousValue + element.value),
    );
    String totalLabel =
        AppLocalizations.of(context)!.totalN(total).replaceFirst(": ", ":\n");
    try {
      final selected = widget.data.singleWhere(
        (element) => element.isSelected,
      );
      totalLabel = "${selected.title}:\n${widget.formatData(selected.value)}";
    } catch (error) {
      // do nothing
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: 250.0,
          child: Stack(
            children: [
              StreamBuilder<List<PieChartSectionData>>(
                stream: generateChartData(),
                builder: (context, snapshot) {
                  return PieChart(
                    PieChartData(
                      centerSpaceRadius: double.infinity,
                      sections: snapshot.data,
                      startDegreeOffset: 270,
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          if (event.isInterestedForInteractions &&
                              widget.onTapSection != null &&
                              event.runtimeType == FlTapDownEvent) {
                            if (response == null ||
                                response.touchedSection == null ||
                                response.touchedSection!.touchedSectionIndex ==
                                    -1) {
                              widget.onTapSection!(null);
                            } else {
                              final sectionTitle = widget
                                  .data[response
                                      .touchedSection!.touchedSectionIndex]
                                  .title;
                              widget.onTapSection!(sectionTitle);
                            }
                          }
                        },
                      ),
                    ),
                    swapAnimationDuration: 350.ms,
                    swapAnimationCurve: Curves.easeInOutBack,
                  );
                },
              ),
              IgnorePointer(
                child: Center(
                  child: Text(
                    totalLabel,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DefaultPieChartSkeleton extends StatelessWidget {
  const DefaultPieChartSkeleton({super.key});

  Stream<List<PieChartSectionData>> randomChartSections(Color color) async* {
    final Random rand = Random();
    while (true) {
      final List<PieChartSectionData> result = [];
      for (int i = 0; i < 6; ++i) {
        result.add(
          PieChartSectionData(
            title: "",
            value: rand.nextDouble() * 10.0 + 10.0,
            color: color.withOpacity(rand.nextDouble() * 0.5 + 0.2),
            radius: 60.0,
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
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Skeleton(),
        ),
        SizedBox(
          height: 250.0,
          child: Stack(
            children: [
              StreamBuilder<List<PieChartSectionData>>(
                stream: randomChartSections(
                  Theme.of(context).colorScheme.primaryContainer,
                ),
                builder: (context, snapshot) {
                  return PieChart(
                    PieChartData(
                      centerSpaceRadius: double.infinity,
                      sections: snapshot.data,
                      startDegreeOffset: 270,
                      pieTouchData: PieTouchData(enabled: false),
                    ),
                    swapAnimationDuration: 350.ms,
                    swapAnimationCurve: Curves.easeOutBack,
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
                          (Skeleton.defaultAnimationDuration.inMilliseconds *
                                  0.5)
                              .toInt(),
                    ),
                  ),
              const Center(
                child: SizedBox(
                  width: 80.0,
                  child: Skeleton(
                    widthFactor: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
