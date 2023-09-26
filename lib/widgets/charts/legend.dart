import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/utils/color_utils.dart';
import 'package:pile_of_shame/widgets/charts/legend_entry.dart';

class Legend extends StatelessWidget {
  final List<ChartData> data;
  final void Function(String title) onChangeSelection;

  const Legend({
    super.key,
    required this.data,
    required this.onChangeSelection,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> legend = [];
    for (var i = 0; i < data.length; ++i) {
      final section = data[i];
      final color = ColorUtils.stringToColor(section.title);

      legend.add(LegendEntry(
        color: color,
        text: section.title,
        onTap: () {
          onChangeSelection(section.title);
        },
        isSelected: section.isSelected,
      ));
    }
    return Wrap(
      runSpacing: 4.0,
      spacing: 8.0,
      children: legend,
    );
  }
}

class LegendSkeleton extends StatelessWidget {
  const LegendSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      runSpacing: 4.0,
      spacing: 8.0,
      children: [
        LegendEntrySkeleton(
          textWidth: 60.0,
        ),
        LegendEntrySkeleton(
          textWidth: 75.0,
        ),
        LegendEntrySkeleton(
          textWidth: 55.0,
        ),
        LegendEntrySkeleton(
          textWidth: 90.0,
        ),
        LegendEntrySkeleton(
          textWidth: 70.0,
        ),
      ],
    );
  }
}
