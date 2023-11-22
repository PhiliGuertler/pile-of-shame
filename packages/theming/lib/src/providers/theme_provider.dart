import 'package:flutter/material.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theming/src/models/theme.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeSettings extends _$ThemeSettings with Persistable {
  static const String storageKey = 'theme';

  @override
  FutureOr<AppTheme> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return AppTheme.fromJson(storedJSON);
    }
    return const AppTheme();
  }

  Future<void> setPrimaryColor(Color primaryColor) async {
    state = await AsyncValue.guard(() async {
      final AppTheme update = state.maybeWhen(
        data: (data) => data.copyWith(primaryColor: primaryColor),
        orElse: () => AppTheme(primaryColor: primaryColor),
      );
      await persistJSON(storageKey, update.toJson());
      return update;
    });
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = await AsyncValue.guard(() async {
      final AppTheme update = state.maybeWhen(
        data: (data) => data.copyWith(themeMode: themeMode),
        orElse: () => AppTheme(themeMode: themeMode),
      );
      await persistJSON(storageKey, update.toJson());
      return update;
    });
  }

  Future<void> setLocale(String? locale) async {
    state = await AsyncValue.guard(() async {
      final AppTheme update = state.maybeWhen(
        data: (data) => data.copyWith(locale: locale),
        orElse: () => AppTheme(locale: locale),
      );
      await persistJSON(storageKey, update.toJson());
      return update;
    });
  }
}
