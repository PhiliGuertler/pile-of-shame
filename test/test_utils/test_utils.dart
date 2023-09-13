import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class TestUtils {
  const TestUtils._();

  static Future<BuildContext> setupBuildContextForLocale(
      WidgetTester tester, String locale) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      home: Container(),
    ));

    return tester.element(find.byType(Container));
  }
}
