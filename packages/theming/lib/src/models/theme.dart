import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme.freezed.dart';
part 'theme.g.dart';

class ColorIntConv implements JsonConverter<Color, int> {
  const ColorIntConv();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}

@freezed
class AppTheme with _$AppTheme {
  const factory AppTheme({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(Color(0xFF3B0000)) @ColorIntConv() Color primaryColor,
    @Default(null) String? locale,
  }) = _AppTheme;
  const AppTheme._();

  ColorScheme computeColorScheme(bool isLightTheme) {
    final Color harmonizedColor = primaryColor.harmonizeWith(primaryColor);
    final ColorScheme result = ColorScheme.fromSeed(
      seedColor: harmonizedColor,
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
    );
    return result;
  }

  factory AppTheme.fromJson(Map<String, dynamic> json) =>
      _$AppThemeFromJson(json);
}
