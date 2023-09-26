import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/utils/color_utils.dart';

String defaultFormatData(double data) {
  return (data == data.roundToDouble() ? data.toInt() : data).toString();
}

class DefaultPieChart extends StatelessWidget {
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
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];
    for (var i = 0; i < data.length; ++i) {
      final section = data[i];
      final color = ColorUtils.stringToColor(section.title);
      sections.add(PieChartSectionData(
        color: color,
        title: formatData(section.value),
        value: section.value,
        titleStyle: TextStyle(
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
        radius: section.isSelected ? 70.0 : 60.0,
      ));
    }

    final total = formatData(
      data.fold(0.0, (previousValue, element) => previousValue + element.value),
    );
    String totalLabel = total;
    try {
      final selected = data.singleWhere(
        (element) => element.isSelected,
      );
      totalLabel = "${selected.title}:\n${formatData(selected.value)}";
    } catch (error) {
      // do nothing
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: 250.0,
          child: Stack(
            children: [
              Center(
                  child: Text(
                totalLabel,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )),
              PieChart(
                PieChartData(
                  centerSpaceRadius: double.infinity,
                  sectionsSpace: 0,
                  sections: sections,
                  startDegreeOffset: 270,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions &&
                          onTapSection != null) {
                        if (response == null ||
                            response.touchedSection == null ||
                            response.touchedSection!.touchedSectionIndex ==
                                -1) {
                          onTapSection!(null);
                        } else {
                          final sectionTitle =
                              data[response.touchedSection!.touchedSectionIndex]
                                  .title;
                          onTapSection!(sectionTitle);
                        }
                      }
                    },
                  ),
                ),
                swapAnimationDuration: 250.ms,
                swapAnimationCurve: Curves.easeOutBack,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
