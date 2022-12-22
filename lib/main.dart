import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart';
import 'src/screens/games.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // wait until the system locale was found to display dates and texts according to the locale
  findSystemLocale().then(
    (value) {
      runApp(const PileOfShameApp());
    },
  );
}

class PileOfShameApp extends StatelessWidget {
  const PileOfShameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pile of Shame',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepOrange,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const GameScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
