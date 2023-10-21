import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

import '../test_utils/test_utils.dart';

void main() {
  group("GamePlatformFamily", () {
    group("Locale: de", () {
      testWidgets("returns the correct string for Microsoft",
          (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result = GamePlatformFamily.microsoft
            .toLocale(AppLocalizations.of(context)!);

        expect(result, "Microsoft");
      });
      testWidgets("returns the correct string for Sony", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result =
            GamePlatformFamily.sony.toLocale(AppLocalizations.of(context)!);

        expect(result, "Sony");
      });
      testWidgets("returns the correct string for Nintendo",
          (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result =
            GamePlatformFamily.nintendo.toLocale(AppLocalizations.of(context)!);

        expect(result, "Nintendo");
      });
      testWidgets("returns the correct string for PC", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result =
            GamePlatformFamily.pc.toLocale(AppLocalizations.of(context)!);

        expect(result, "PC");
      });
      testWidgets("returns the correct string for Misc", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "de");

        final result =
            GamePlatformFamily.misc.toLocale(AppLocalizations.of(context)!);

        expect(result, "Sonstige");
      });
    });
    group("Locale: en", () {
      testWidgets("returns the correct string for Microsoft",
          (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result = GamePlatformFamily.microsoft
            .toLocale(AppLocalizations.of(context)!);

        expect(result, "Microsoft");
      });
      testWidgets("returns the correct string for Sony", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result =
            GamePlatformFamily.sony.toLocale(AppLocalizations.of(context)!);

        expect(result, "Sony");
      });
      testWidgets("returns the correct string for Nintendo",
          (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result =
            GamePlatformFamily.nintendo.toLocale(AppLocalizations.of(context)!);

        expect(result, "Nintendo");
      });
      testWidgets("returns the correct string for PC", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result =
            GamePlatformFamily.pc.toLocale(AppLocalizations.of(context)!);

        expect(result, "PC");
      });
      testWidgets("returns the correct string for Misc", (widgetTester) async {
        final BuildContext context =
            await TestUtils.setupBuildContextForLocale(widgetTester, "en");

        final result =
            GamePlatformFamily.misc.toLocale(AppLocalizations.of(context)!);

        expect(result, "Misc");
      });
    });
  });
}
