import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'src/screens/games.dart';

void main() {
  Intl.defaultLocale = 'de_DE';
  initializeDateFormatting('de_DE', null).then(
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
      debugShowCheckedModeBanner: false,
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
    );
  }
}
