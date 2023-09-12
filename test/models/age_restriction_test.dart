import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';

import '../test_utils/test_utils.dart';

void main() {
  group("USK colors", () {
    test("USK-0 is white", () {
      expect(USK.usk0.color, Colors.white);
    });
    test("USK-6 is yellow", () {
      expect(USK.usk6.color, Colors.yellow);
    });
    test("USK-12 is green", () {
      expect(USK.usk12.color, Colors.green);
    });
    test("USK-16 is blue", () {
      expect(USK.usk16.color, Colors.blue);
    });
    test("USK-18 is red", () {
      expect(USK.usk18.color, Colors.red);
    });
  });
  group("USK age-values", () {
    test("USK-0 is 0", () {
      expect(USK.usk0.age, 0);
    });
    test("USK-6 is 6", () {
      expect(USK.usk6.age, 6);
    });
    test("USK-12 is 12", () {
      expect(USK.usk12.age, 12);
    });
    test("USK-16 is 16", () {
      expect(USK.usk16.age, 16);
    });
    test("USK-18 is 18", () {
      expect(USK.usk18.age, 18);
    });
  });

  group("toRatedString", () {
    testWidgets("returns the correct string with Locale 'de'",
        (widgetTester) async {
      final BuildContext context =
          await TestUtils.setupBuildContextForLocale(widgetTester, "de");

      final result = USK.usk12.toRatedString(context);

      expect(result, "Freigegeben ab 12 Jahren");
    });
    testWidgets("returns the correct string with Locale 'en'",
        (widgetTester) async {
      final BuildContext context =
          await TestUtils.setupBuildContextForLocale(widgetTester, "en");

      final result = USK.usk12.toRatedString(context);

      expect(result, "Rated 12");
    });
  });
}
