import 'package:flutter/material.dart';

import 'src/screens/games.dart';

void main() {
  runApp(const PileOfShameApp());
}

class PileOfShameApp extends StatelessWidget {
  const PileOfShameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}
