import 'package:freezed_annotation/freezed_annotation.dart';

part 'default_pie_chart_data.freezed.dart';

@freezed
class DefaultPieChartData with _$DefaultPieChartData {
  const factory DefaultPieChartData({
    required String title,
    required double value,
  }) = _DefaultPieChartData;
}
