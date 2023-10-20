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
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/models/theming/theme.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
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

  setUp(() {
    mockFileUtils = MockFileUtils();

    container = ProviderContainer(
      overrides: [
        fileUtilsProvider.overrideWithValue(mockFileUtils),
        gameByIdProvider('witcher-3')
            .overrideWith((provider) => TestGames.gameWitcher3),
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

    const themeModes = [
      ThemeMode.dark,
      ThemeMode.light,
    ];

    const languages = {
      "de": "Füge Deine Spiele zur Bibliothek hinzu",
      "en": "Add your games to the library",
    };

    const screenSizes = [
      ScreenSizes.android,
      ScreenSizes.android7Inch,
      ScreenSizes.android10Inch,
    ];

    for (final language in languages.entries) {
      for (final themeMode in themeModes) {
        for (final screenSize in screenSizes) {
          await ScreenshotUtils.takeDecoratedScreenshot(
            tester: tester,
            pageName: pageName,
            screen: const AddGameScreen(),
            screenSize: screenSize,
            appTheme: AppTheme(locale: language.key, themeMode: themeMode),
            description: language.value,
            container: container,
          );
        }
      }
    }
  });
  testGoldens("Game details screen", (tester) async {
    const String pageName = "game_details";

    const themeModes = [
      ThemeMode.dark,
      ThemeMode.light,
    ];

    const languages = {
      "de": "Sieh Dir Details zu Deinen Spielen an",
      "en": "Display the details of your games",
    };

    const screenSizes = [
      ScreenSizes.android,
      ScreenSizes.android7Inch,
      ScreenSizes.android10Inch,
    ];

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
            appTheme: AppTheme(locale: language.key, themeMode: themeMode),
            description: language.value,
            container: container,
          );
        }
      }
    }
  });
}
