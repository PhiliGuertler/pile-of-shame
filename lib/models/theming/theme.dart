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
  const AppTheme._();

  factory AppTheme({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(null) String? locale,
    @Default(Color(0xFF3B0000)) @ColorIntConv() Color primaryColor,
  }) = _AppTheme;

  ColorScheme computeColorScheme(bool isLightTheme) {
    Color harmonizedColor = primaryColor.harmonizeWith(primaryColor);
    ColorScheme result = ColorScheme.fromSeed(
      seedColor: harmonizedColor,
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
    );
    return result;
  }

  factory AppTheme.fromJson(Map<String, dynamic> json) =>
      _$AppThemeFromJson(json);
}
