import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_data.freezed.dart';

@freezed
class ChartData with _$ChartData {
  const factory ChartData({
    required String title,
    required double value,
    @Default(false) bool isSelected,
    Color? color,
  }) = _ChartData;
}
