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
      title: 'Pile of Shame',
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}
