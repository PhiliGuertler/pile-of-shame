import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/app.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/screens/add_or_edit_game_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/theming/theme.dart';
import 'package:pile_of_shame/utils/constants.dart';

ThemeData _createThemeData(ColorScheme colorScheme) => ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: defaultPaddingX),
      ),
    );

Widget _getScreenWrapper({
  required Widget child,
  required AppTheme appTheme,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: DynamicColorBuilder(
      builder: (_, __) {
        final ColorScheme lightColorScheme = appTheme.computeColorScheme(true);
        final ColorScheme darkColorScheme = appTheme.computeColorScheme(false);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
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
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
          ],
          locale: appTheme.locale != null ? Locale(appTheme.locale!) : null,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              return Column(
                children: [
                  Container(
                    height: 24,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Expanded(child: child),
                ],
              );
            },
          ),
        );
      },
    ),
  );
}

enum ScreenSizes {
  android(size: Size(1107, 1968), density: 3),
  android7Inch(size: Size(1206, 2144), density: 2),
  android10Inch(size: Size(1449, 2576), density: 2),
  ipadPro(size: Size(2048, 2732), density: 2),
  iphone8(size: Size(1242, 2208), density: 3),
  iphoneXsMax(size: Size(1242, 2688), density: 3),
  ;

  final Size size;
  final double density;

  const ScreenSizes({required this.size, required this.density});
}

Future<void> _takeScreenshot({
  required WidgetTester tester,
  required Widget widget,
  required String pageName,
  required bool isFinal,
  required ScreenSizes size,
  CustomPump? customPump,
}) async {
  await tester.pumpWidgetBuilder(widget);
  await multiScreenGolden(
    tester,
    pageName,
    customPump: customPump,
    devices: [
      Device(
        name: isFinal ? "final" : "screen",
        size: size.size / size.density,
        devicePixelRatio: size.density,
      ),
    ],
  );
}

Widget _decorateScreen(
  Widget image,
  String descriptionText,
  AppTheme appTheme,
) {
  final ColorScheme colorScheme = appTheme.computeColorScheme(false);

  return Builder(
    builder: (context) {
      final textTheme = Theme.of(context).textTheme;
      return ColoredBox(
        color: colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text(
                  descriptionText,
                  style: textTheme.headlineMedium
                      ?.copyWith(color: colorScheme.onPrimaryContainer),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: colorScheme.onPrimaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: image,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _takeDecoratedScreenshot({
  required WidgetTester tester,
  required Widget screen,
  required String pageName,
  required ScreenSizes screenSize,
  required AppTheme appTheme,
}) async {
  await _takeScreenshot(
    tester: tester,
    isFinal: false,
    widget: _getScreenWrapper(
      child: screen,
      appTheme: appTheme,
    ),
    pageName: pageName,
    size: screenSize,
  );
  final screenFile =
      File("./test/generate_screenshots/goldens/$pageName.screen.png");
  final memoryImage = MemoryImage(screenFile.readAsBytesSync());
  final image = Image(image: memoryImage);

  await _takeScreenshot(
    tester: tester,
    widget: _decorateScreen(image, "Füge Deine Spiele hinzu", appTheme),
    pageName: pageName,
    isFinal: true,
    size: screenSize,
  );

  screenFile.deleteSync();
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();

  testGoldens("Add game screen", (tester) async {
    const String pageName = "add_game";

    const screenSizes = [
      ScreenSizes.android,
      ScreenSizes.android7Inch,
      ScreenSizes.android10Inch,
    ];

    for (final screenSize in screenSizes) {
      await _takeDecoratedScreenshot(
        tester: tester,
        pageName: "$pageName-${screenSize.name}",
        screen: const AddGameScreen(),
        screenSize: screenSize,
        appTheme: AppTheme(locale: 'de', themeMode: ThemeMode.dark),
      );
    }
  });

  // testGoldens(
  //   "Example golden",
  //   (tester) async {
  //     const String pageName = "root_page";
  //     const screenSize = ScreenSizes.android;
  //     await _takeScreenshot(
  //       tester: tester,
  //       isFinal: false,
  //       widget: _getScreenWrapper(
  //         child: const AddGameScreen(),
  //         appTheme: AppTheme(locale: 'de'),
  //       ),
  //       pageName: pageName,
  //       size: screenSize,
  //     );
  //     final screenFile =
  //         File("./test/generate_screenshots/goldens/$pageName.screen.png");
  //     final memoryImage = MemoryImage(screenFile.readAsBytesSync());
  //     final image = Image(image: memoryImage);

  //     await _takeScreenshot(
  //       tester: tester,
  //       widget: _decorateScreen(image, "Füge Deine Spiele hinzu"),
  //       pageName: pageName,
  //       isFinal: true,
  //       size: screenSize,
  //     );

  //     screenFile.deleteSync();
  //   },
  // );
}
