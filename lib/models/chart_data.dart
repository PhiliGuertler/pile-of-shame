import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_data.freezed.dart';

@freezed
abstract class ChartData with _$ChartData {
  const factory ChartData({
    required String title,
    required double value,
    double? secondaryValue,
    @Default(false) bool isSelected,
    @Default(false) bool isSecondarySelected,
    Color? color,
    Widget? alternativeTitle,
  }) = _ChartData;
}
