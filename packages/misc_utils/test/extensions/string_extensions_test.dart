import 'package:flutter_test/flutter_test.dart';
import 'package:misc_utils/src/extensions/string_extensions.dart';

void main() {
  group("removeDiacritics", () {
    test("does not alter strings without diacritics", () {
      const String testString = "The quick fox jumps over the lazy dog";
      final result = testString.removeDiacritics();

      expect(result, testString);
    });
    test("removes diacritcs from a string correctly", () {
      const String testString = "Pokémon Ätherçuss";
      const String expectedResult = "Pokemon Athercuss";

      final result = testString.removeDiacritics();

      expect(result, expectedResult);
    });
  });

  group("prepareForCaseInsensitiveSearch", () {
    test("correctly transforms simplifies complex search string", () {
      const String testString = "Pokémon Ätherçuss";
      const String expectedResult = "pokemon athercuss";

      final result = testString.prepareForCaseInsensitiveSearch();

      expect(result, expectedResult);
    });
  });
}
