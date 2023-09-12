import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';

import '../test_utils/test_utils.dart';

void main() {
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
