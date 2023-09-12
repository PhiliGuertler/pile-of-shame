import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

import '../test_utils/test_utils.dart';

void main() {
  group("GamePlatformFamily", () {
    group("Locale: de", () {
      testWidgets("returns the correct string for Microsoft",
          (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result = GamePlatformFamily.microsoft.toLocale(context);

        expect(result, "Microsoft");
      });
      testWidgets("returns the correct string for Sony", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result = GamePlatformFamily.sony.toLocale(context);

        expect(result, "Sony");
      });
      testWidgets("returns the correct string for Nintendo",
          (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result = GamePlatformFamily.nintendo.toLocale(context);

        expect(result, "Nintendo");
      });
      testWidgets("returns the correct string for PC", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result = GamePlatformFamily.pc.toLocale(context);

        expect(result, "PC");
      });
      testWidgets("returns the correct string for Misc", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result = GamePlatformFamily.misc.toLocale(context);

        expect(result, "Sonstige");
      });
    });
    group("Locale: en", () {
      testWidgets("returns the correct string for Microsoft",
          (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result = GamePlatformFamily.microsoft.toLocale(context);

        expect(result, "Microsoft");
      });
      testWidgets("returns the correct string for Sony", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result = GamePlatformFamily.sony.toLocale(context);

        expect(result, "Sony");
      });
      testWidgets("returns the correct string for Nintendo",
          (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result = GamePlatformFamily.nintendo.toLocale(context);

        expect(result, "Nintendo");
      });
      testWidgets("returns the correct string for PC", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result = GamePlatformFamily.pc.toLocale(context);

        expect(result, "PC");
      });
      testWidgets("returns the correct string for Misc", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result = GamePlatformFamily.misc.toLocale(context);

        expect(result, "Misc");
      });
    });
  });

  group("GamePlatform", () {
    test("Assembles icon path as expected", () {
      final iconPath = GamePlatform.playStation5.iconPath;
      expect(iconPath, 'assets/platforms/icons/sony/ps5.webp');
    });
    test("Assembles text-logo path as expected", () {
      final iconPath = GamePlatform.nintendo3DS.textLogoPath;
      expect(
          iconPath, 'assets/platforms/text_logos/nintendo/nintendo_3ds.webp');
    });
    test("Assembles controller-logo path as expected", () {
      final iconPath = GamePlatform.xbox360.controllerLogoPath;
      expect(iconPath, 'assets/platforms/controllers/microsoft/xbox_360.webp');
    });
  });
}
