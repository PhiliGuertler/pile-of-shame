import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/theming/theme.dart';
import 'package:pile_of_shame/providers/mixins/persistable_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class AppThemeSettings extends _$AppThemeSettings with Persistable {
  static const String storageKey = 'app-theme';

  @override
  FutureOr<AppTheme> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return AppTheme.fromJson(storedJSON);
    }
    return AppTheme();
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
