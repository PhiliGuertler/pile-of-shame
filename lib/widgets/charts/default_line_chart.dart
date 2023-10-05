import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/models/chart_data.dart';

String defaultFormatData(double data) {
  return (data == data.roundToDouble() ? data.toInt() : data).toString();
}

double defaultComputeSum(List<ChartData> data) {
  return data.fold(
    0.0,
    (previousValue, element) => previousValue + element.value,
  );
}

class DefaultLineChart extends StatefulWidget {
  final List<ChartData> data;
  final double interval;
  final String Function(double data) formatData;
  final double Function(List<ChartData> data) computeSum;
  final void Function(String? title)? onTapSection;

  const DefaultLineChart({
    super.key,
    required this.data,
    required this.interval,
    this.formatData = defaultFormatData,
    this.computeSum = defaultComputeSum,
    this.onTapSection,
  });

  @override
  State<DefaultLineChart> createState() => _DefaultLineChartState();
}

class _DefaultLineChartState extends State<DefaultLineChart> {
  bool skipAnimation = false;

  Stream<LineChartBarData> generateChartData(
    Color backgroundColor,
  ) async* {
    final average = widget.data.fold(
          0.0,
          (previousValue, element) => previousValue + element.value,
        ) /
        widget.data.length;
    final List<FlSpot> spots = [];
    final List<FlSpot> initialSpots = [];
    for (var i = 0; i < widget.data.length; ++i) {
      final y = widget.data[i].value;
      final x = widget.data[i].secondaryValue ?? i * widget.interval;
      spots.add(FlSpot(x, y));
      initialSpots.add(FlSpot(x, average));
    }
    final LineChartBarData data = LineChartBarData(
      spots: spots,
      barWidth: 3.0,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      color: backgroundColor,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor.withOpacity(0.7),
            backgroundColor.withOpacity(0.1),
          ].toList(),
        ),
      ),
    );
    final LineChartBarData initialData = LineChartBarData(
      spots: initialSpots,
      barWidth: 3.0,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      color: backgroundColor,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor.withOpacity(0.7),
            backgroundColor.withOpacity(0.1),
          ].toList(),
        ),
      ),
    );
    if (!skipAnimation) {
      yield initialData;
      await Future.delayed(200.ms);
      if (context.mounted) {
        setState(() {
          skipAnimation = true;
        });
      }
    }
    yield data;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.0,
      child: StreamBuilder<LineChartBarData>(
        stream: generateChartData(
          Theme.of(context).colorScheme.primaryContainer,
        ),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              minY: 0.0,
              maxY: widget.data.fold<double>(
                0.0,
                (previousValue, element) => element.value > previousValue
                    ? element.value
                    : previousValue,
              ),
              lineBarsData: snapshot.hasData ? [snapshot.data!] : [],
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                rightTitles: AxisTitles(),
                topTitles: AxisTitles(),
                leftTitles: AxisTitles(),
              ),
              borderData: FlBorderData(show: false),
            ),
            duration: 150.ms,
            curve: Curves.easeInOutBack,
          );
        },
      ),
    );
  }
}
