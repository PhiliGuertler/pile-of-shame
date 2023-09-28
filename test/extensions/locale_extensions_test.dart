import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/extensions/locale_extensions.dart';

void main() {
  group("LanguageName", () {
    test("throws if the country code is not supported", () {
      const Locale testLocale = Locale("fr");
      try {
        testLocale.fullName();
      } catch (error) {
        expect(
          error.toString(),
          "Exception: LanguageCode 'fr' is not supported",
        );
        return;
      }
      fail("No exception thrown");
    });
    test("returns 'Deutsch' for Locale 'de'", () {
      const Locale testLocale = Locale("de");
      expect(testLocale.fullName(), "Deutsch");
    });
    test("returns 'English' for Locale 'en'", () {
      const Locale testLocale = Locale("en");
      expect(testLocale.fullName(), "English");
    });
  });

  group("LanguageIcon", () {
    test("throws if the country code is not supported", () {
      const Locale testLocale = Locale("fr");
      try {
        testLocale.countryAssetPath();
      } catch (error) {
        expect(error.toString(), "Exception: Language 'fr' is not supported");
        return;
      }
      fail("no exception thrown");
    });
    test("returns correct asset for Locale 'de'", () {
      const Locale testLocale = Locale("de");
      expect(testLocale.countryAssetPath(), "assets/languages/german.png");
    });
    test("returns correct asset for Locale 'en'", () {
      const Locale testLocale = Locale("en");
      expect(testLocale.countryAssetPath(), "assets/languages/english.png");
    });
  });
}
