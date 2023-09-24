import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/models/default_pie_chart_data.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/legend_entry.dart';
import 'package:pile_of_shame/utils/color_utils.dart';

class DefaultPieChart extends StatefulWidget {
  final List<DefaultPieChartData> data;
  final String? total;
  final String title;

  const DefaultPieChart({
    super.key,
    required this.data,
    required this.title,
    this.total,
  });

  @override
  State<DefaultPieChart> createState() => _DefaultPieChartState();
}

class _DefaultPieChartState extends State<DefaultPieChart> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];
    List<Widget> legend = [];
    for (var i = 0; i < widget.data.length; ++i) {
      final section = widget.data[i];
      final color = ColorUtils.stringToColor(section.title);
      sections.add(PieChartSectionData(
        color: color,
        title: (section.value == section.value.roundToDouble()
                ? section.value.toInt()
                : section.value)
            .toString(),
        value: section.value,
        titleStyle: TextStyle(
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
        radius: selectedIndex == i ? 60.0 : 50.0,
      ));

      legend.add(LegendEntry(
          color: color, text: section.title, isSelected: selectedIndex == i));
    }

    return Column(
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Wrap(
          runSpacing: 4.0,
          spacing: 8.0,
          children: legend,
        ),
        SizedBox(
          height: 250.0,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: double.infinity,
                  sectionsSpace: 0,
                  sections: sections,
                  startDegreeOffset: 270,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions) {
                        if (response == null ||
                            response.touchedSection == null) {
                          setState(() {
                            selectedIndex = -1;
                          });
                        } else {
                          setState(() {
                            selectedIndex =
                                response.touchedSection!.touchedSectionIndex;
                          });
                        }
                      }
                    },
                  ),
                ),
                swapAnimationDuration: 150.ms,
                swapAnimationCurve: Curves.easeInOut,
              ),
              if (widget.total != null)
                Center(
                    child: Text(
                  widget.total!,
                  style: Theme.of(context).textTheme.displaySmall,
                )),
            ],
          ),
        ),
      ],
    );
  }
}
