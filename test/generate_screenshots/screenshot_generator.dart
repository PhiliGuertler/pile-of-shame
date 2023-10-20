import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/screens/add_or_edit_game_screen.dart';
import 'package:pile_of_shame/features/games/game_details/screens/game_details_screen.dart';
import 'package:pile_of_shame/features/root_page/root_page.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/theming/theme.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/providers/hardware/hardware_provider.dart';
import 'package:pile_of_shame/utils/file_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_resources/test_games.dart';
@GenerateNiceMocks([MockSpec<FileUtils>(), MockSpec<File>()])
import 'screenshot_generator.mocks.dart';
import 'screenshot_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // await loadAppFonts();

  late ProviderContainer container;
  late MockFileUtils mockFileUtils;

  const screenSizes = [
    ScreenSizes.android,
    ScreenSizes.android7Inch,
    ScreenSizes.android10Inch,
  ];
  const themeModes = [
    ThemeMode.dark,
    ThemeMode.light,
  ];

  setUp(() {
    mockFileUtils = MockFileUtils();

    container = ProviderContainer(
      overrides: [
        fileUtilsProvider.overrideWithValue(mockFileUtils),
        gameByIdProvider('witcher-3')
            .overrideWith((provider) => TestGames.gameWitcher3),
        gamesGroupedProvider.overrideWith(
          (ref) => {
            "": [
              TestGames.gameDarkSouls,
              TestGames.gameDistance,
              TestGames.gameOriAndTheBlindForest,
              TestGames.gameOuterWilds,
              TestGames.gameSsx3,
              TestGames.gameWitcher3,
            ],
          },
        ),
        hasGamesProvider.overrideWith((ref) => true),
        gamesFilteredTotalPriceProvider.overrideWith((ref) => 999),
        gamesFilteredTotalAmountProvider.overrideWith((ref) => 6),
        hasHardwareProvider.overrideWith((ref) => true),
        hardwarePlatformsProvider.overrideWith(
          (ref) => [
            TestGames.gameDarkSouls.platform,
            TestGames.gameDistance.platform,
            TestGames.gameSsx3.platform,
          ],
        ),
        sortedHardwareByPlatformProvider(TestGames.gameDarkSouls.platform)
            .overrideWith(
          (ref) => [
            VideoGameHardware(
              id: "dark-souls",
              name: "Console",
              price: 499.95,
              platform: TestGames.gameDarkSouls.platform,
              lastModified: DateTime(2023),
              createdAt: DateTime(2023),
            ),
          ],
        ),
        sortedHardwareByPlatformProvider(TestGames.gameSsx3.platform)
            .overrideWith(
          (ref) => [
            VideoGameHardware(
              id: "distance",
              name: "Console",
              price: 419.95,
              platform: TestGames.gameDistance.platform,
              lastModified: DateTime(2023),
              createdAt: DateTime(2023),
            ),
          ],
        ),
        sortedHardwareByPlatformProvider(TestGames.gameSsx3.platform)
            .overrideWith(
          (ref) => [
            VideoGameHardware(
              id: "ssx",
              name: "Console",
              wasGifted: true,
              platform: TestGames.gameSsx3.platform,
              lastModified: DateTime(2023),
              createdAt: DateTime(2023),
            ),
          ],
        ),
        hardwareTotalPriceByPlatformProvider(TestGames.gameDarkSouls.platform)
            .overrideWith((provider) => 499.95),
        hardwareTotalPriceByPlatformProvider(TestGames.gameDistance.platform)
            .overrideWith((provider) => 419.95),
        hardwareTotalPriceByPlatformProvider(TestGames.gameSsx3.platform)
            .overrideWith((provider) => 0),
      ],
    );

    when(mockFileUtils.openFile(gameFileName)).thenAnswer(
      (realInvocation) async => File('test_resources/game-store.json'),
    );

    SharedPreferences.setMockInitialValues(
      {
        "custom-game-displays": jsonEncode(
          const CustomGameDisplaySettings(hasFancyAnimations: false).toJson(),
        ),
      },
    );
  });

  testGoldens("Add game screen", (tester) async {
    const String pageName = "add_game";

    const languages = {
      "de": "Füge Deine Spiele zur Bibliothek hinzu",
      "en": "Add your games to the library",
    };

    for (final language in languages.entries) {
      for (final themeMode in themeModes) {
        for (final screenSize in screenSizes) {
          await ScreenshotUtils.takeDecoratedScreenshot(
            tester: tester,
            pageName: pageName,
            screen: const AddGameScreen(),
            screenSize: screenSize,
            appTheme: AppTheme(
              locale: language.key,
              themeMode: themeMode,
            ),
            description: language.value,
            container: container,
          );
        }
      }
    }
  });
  testGoldens("Game details screen", (tester) async {
    const String pageName = "game_details";

    const languages = {
      "de": "Sieh Dir Details zu Deinen Spielen an",
      "en": "Display the details of your games",
    };

    for (final language in languages.entries) {
      for (final themeMode in themeModes) {
        for (final screenSize in screenSizes) {
          await ScreenshotUtils.takeDecoratedScreenshot(
            tester: tester,
            pageName: pageName,
            screen: const GameDetailsScreen(
              gameId: 'witcher-3',
            ),
            screenSize: screenSize,
            appTheme: AppTheme(
              locale: language.key,
              themeMode: themeMode,
            ),
            description: language.value,
            container: container,
          );
        }
      }
    }
  });
  testGoldens("Game list screen", (tester) async {
    const String pageName = "game_list";

    const languages = {
      "de": "Behalte den Überblick über all Deine Spiele",
      "en": "Keep track of all your games",
    };

    for (final language in languages.entries) {
      for (final themeMode in themeModes) {
        for (final screenSize in screenSizes) {
          await ScreenshotUtils.takeDecoratedScreenshot(
            tester: tester,
            pageName: pageName,
            screen: const RootPage(),
            screenSize: screenSize,
            appTheme: AppTheme(
              locale: language.key,
              themeMode: themeMode,
            ),
            description: language.value,
            container: container,
          );
        }
      }
    }
  });
  testGoldens("Hardware list screen", (tester) async {
    const String pageName = "hardware_list";

    const languages = {
      "de": "Behalte den Überblick über Deine Spielehardware",
      "en": "Keep track of all your gaming hardware",
    };

    for (final language in languages.entries) {
      for (final themeMode in themeModes) {
        for (final screenSize in screenSizes) {
          await ScreenshotUtils.takeDecoratedScreenshot(
            tester: tester,
            pageName: pageName,
            screen: const RootPage(),
            interactBeforeScreenshot: (tester) async {
              for (int i = 0; i < 5; ++i) {
                await tester.pump(const Duration(milliseconds: 300));
              }
              await tester.tap(find.byKey(const ValueKey("root_hardware")));
              for (int i = 0; i < 5; ++i) {
                await tester.pump(const Duration(milliseconds: 300));
              }
              await tester.tap(
                find.byKey(
                  ValueKey(
                    "hardware-${TestGames.gameDarkSouls.platform.abbreviation}",
                  ),
                ),
              );
              for (int i = 0; i < 5; ++i) {
                await tester.pump(const Duration(milliseconds: 300));
              }
            },
            screenSize: screenSize,
            appTheme: AppTheme(
              locale: language.key,
              themeMode: themeMode,
            ),
            description: language.value,
            container: container,
          );
        }
      }
    }
  });
}