import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/features/root_page/root_page.dart';

void main() {
  testWidgets(
      'root page transition does not paint over the scaffold or hide ListTile ink',
      (tester) async {
    const scaffoldColor = Color(0xFF201A19);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: scaffoldColor,
            brightness: Brightness.dark,
          ),
          canvasColor: scaffoldColor,
          scaffoldBackgroundColor: scaffoldColor,
        ),
        home: Scaffold(
          backgroundColor: scaffoldColor,
          body: PageTransitionSwitcher(
            transitionBuilder: rootPageTransitionBuilder,
            child: const ListTile(
              key: ValueKey('games'),
              title: Text('Games'),
              onTap: _noop,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final transitionColor = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(FadeThroughTransition),
        matching: find.byType(ColoredBox),
      ).first,
    );
    expect(transitionColor.color, Colors.transparent);
  });
}

void _noop() {}