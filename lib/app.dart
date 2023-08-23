import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/features/root_page/root_page.dart';
import 'package:pile_of_shame/models/theming/theme.dart';
import 'package:pile_of_shame/providers/theming/theme_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

import 'l10n/generated/app_localizations.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> appKey = GlobalKey<NavigatorState>();

class App extends ConsumerWidget {
  const App({super.key});

  ThemeData _createThemeData(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: defaultPaddingX),
        ),
      );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeSettingsProvider);

    return DynamicColorBuilder(builder: (_, __) {
      final AppTheme appTheme =
          theme.maybeWhen(data: (data) => data, orElse: () => AppTheme());

      final ColorScheme lightColorScheme = appTheme.computeColorScheme(true);
      final ColorScheme darkColorScheme = appTheme.computeColorScheme(false);

      return MaterialApp(
        theme: _createThemeData(
          lightColorScheme,
        ),
        darkTheme: _createThemeData(
          darkColorScheme,
        ),
        themeMode: appTheme.themeMode,
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          Intl.defaultLocale = locale?.toLanguageTag();
          return locale;
        },
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        locale: theme.maybeWhen(
          data: (data) => data.locale != null ? Locale(data.locale!) : null,
          orElse: () => null,
        ),
        supportedLocales: AppLocalizations.supportedLocales,
        home: RootPage(
          scrollController: ScrollController(),
        ),
      );
    });
  }
}
