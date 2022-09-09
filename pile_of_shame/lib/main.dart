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
      home: const MyHomePage(title: 'Pile of Shame'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GameScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("TODO: Implement addition");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
