import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/theming/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

const appThemeKey = 'app-theme';

@Riverpod(keepAlive: true)
class AppThemeSettings extends _$AppThemeSettings {
  @override
  FutureOr<AppTheme> build() async {
    return await _loadAppTheme();
  }

  Future<AppTheme> _loadAppTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(appThemeKey);
    if (json != null) {
      return AppTheme.fromJson(jsonDecode(json));
    }
    return AppTheme();
  }

  Future<bool> _persistAppTheme(AppTheme appTheme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String stringifiedJson = jsonEncode(appTheme.toJson());
    return await prefs.setString(appThemeKey, stringifiedJson);
  }

  void setPrimaryColor(Color primaryColor) async {
    state = await AsyncValue.guard(() async {
      AppTheme update = state.maybeWhen(
        data: (data) => data.copyWith(primaryColor: primaryColor),
        orElse: () => AppTheme(primaryColor: primaryColor),
      );
      await _persistAppTheme(update);
      return update;
    });
  }

  void setThemeMode(ThemeMode themeMode) async {
    state = await AsyncValue.guard(() async {
      AppTheme update = state.maybeWhen(
        data: (data) => data.copyWith(themeMode: themeMode),
        orElse: () => AppTheme(themeMode: themeMode),
      );
      await _persistAppTheme(update);
      return update;
    });
  }

  void setLocale(String? locale) async {
    state = await AsyncValue.guard(() async {
      AppTheme update = state.maybeWhen(
        data: (data) => data.copyWith(locale: locale),
        orElse: () => AppTheme(locale: locale),
      );
      await _persistAppTheme(update);
      return update;
    });
  }
}
