import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/extensions/locale_extensions.dart';

void main() {
  group("LanguageName", () {
    test("throws if the country code is not supported", () {
      const Locale testLocale = Locale("zh");
      try {
        testLocale.fullName();
      } catch (error) {
        expect(
          error.toString(),
          "Exception: LanguageCode 'zh' is not supported",
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
}
