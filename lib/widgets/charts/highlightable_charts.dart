import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/widgets/charts/compact_bar_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_bar_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_pie_chart.dart';
import 'package:pile_of_shame/widgets/charts/legend.dart';

mixin HighlightableChart<T extends StatefulWidget> on State<T> {
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

  List<ChartData> highlightData(List<ChartData> data) {
    return data
        .map((e) => e.copyWith(isSelected: e.title == highlightedLabel))
        .toList();
  }
}

class HighlightableBarChart extends StatefulWidget {
  final List<ChartData> data;
  final String Function(double data) formatData;
  final double Function(List<ChartData> data) computeSum;

  const HighlightableBarChart({
    super.key,
    required this.data,
    this.formatData = DefaultBarChart.defaultFormatData,
    this.computeSum = DefaultBarChart.defaultComputeSum,
  });

  @override
  State<HighlightableBarChart> createState() => _HighlightableBarChartState();
}

class _HighlightableBarChartState extends State<HighlightableBarChart>
    with HighlightableChart {
  @override
  Widget build(BuildContext context) {
    final highlightedData = highlightData(widget.data);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Legend(
            data: highlightedData,
            onChangeSelection: handleSectionChange,
          ),
        ),
        DefaultBarChart(
          data: highlightedData,
          formatData: widget.formatData,
          computeSum: widget.computeSum,
          onTapSection: handleSectionChange,
        ),
      ],
    );
  }
}

class HighlightableCompactBarChart extends StatefulWidget {
  final List<ChartData> data;
  final String Function(double data) formatData;
  final bool showBackground;

  const HighlightableCompactBarChart({
    super.key,
    required this.data,
    this.formatData = DefaultBarChart.defaultFormatData,
    this.showBackground = false,
  });

  @override
  State<HighlightableCompactBarChart> createState() =>
      _HighlightableCompactBarChartState();
}

class _HighlightableCompactBarChartState
    extends State<HighlightableCompactBarChart> with HighlightableChart {
  @override
  List<ChartData> highlightData(List<ChartData> data) {
    return data
        .map(
          (e) => e.copyWith(
            isSelected: e.title == highlightedLabel,
            color: e.title == highlightedLabel
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final highlightedData = highlightData(widget.data);

    return CompactBarChart(
      data: highlightedData,
      formatData: widget.formatData,
      onTapSection: handleSectionChange,
      showBackground: widget.showBackground,
    );
  }
}

class HighlightablePieChart extends StatefulWidget {
  final List<ChartData> data;
  final String Function(double data) formatData;

  const HighlightablePieChart({
    super.key,
    required this.data,
    this.formatData = DefaultPieChart.defaultFormatData,
  });

  @override
  State<HighlightablePieChart> createState() => _HighlightablePieChartState();
}

class _HighlightablePieChartState extends State<HighlightablePieChart>
    with HighlightableChart {
  @override
  Widget build(BuildContext context) {
    return DefaultPieChart(
      data: highlightData(widget.data),
      formatData: widget.formatData,
      onTapSection: handleSectionChange,
    );
  }
}