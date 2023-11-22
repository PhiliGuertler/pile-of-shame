import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theming/src/models/theme.dart';
import 'package:theming/src/providers/theme_provider.dart';

/// An application with customizable locale, primary color and theme-mode
/// via themeSettingsProvider.
/// This application defaults to the system language if supported.
class ThemedApp extends ConsumerWidget {
  final double horizontalPadding;

  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Widget home;

  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  const ThemedApp({
    super.key,
    this.horizontalPadding = 24.0,
    this.scaffoldMessengerKey,
    required this.localizationsDelegates,
    required this.supportedLocales,
    required this.home,
  });

  ThemeData _createThemeData(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeSettingsProvider);

    return DynamicColorBuilder(
      builder: (_, __) {
        final AppTheme appTheme = theme.maybeWhen(
          data: (data) => data,
          orElse: () => const AppTheme(),
        );

        final ColorScheme lightColorScheme = appTheme.computeColorScheme(true);
        final ColorScheme darkColorScheme = appTheme.computeColorScheme(false);

        return MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: _createThemeData(
            lightColorScheme,
          ),
          darkTheme: _createThemeData(
            darkColorScheme,
          ),
          themeMode: appTheme.themeMode,
          localeResolutionCallback:
              (Locale? locale, Iterable<Locale> supportedLocales) {
            if (supportedLocales.any(
              (element) => element.languageCode == locale?.languageCode,
            )) {
              Intl.defaultLocale = locale?.toLanguageTag();
            } else {
              Intl.defaultLocale = "en";
              return const Locale("en");
            }
            return locale;
          },
          locale: theme.maybeWhen(
            data: (data) => data.locale != null ? Locale(data.locale!) : null,
            orElse: () => null,
          ),
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationsDelegates,
          home: home,
        );
      },
    );
  }
}
