import 'package:flutter/material.dart';

import '../models/game.dart';

class GameDetails extends StatelessWidget {
  const GameDetails({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    num price = game.price != null ? game.price! : 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Column(children: [
        Text(game.title),
        Text(game.platform),
        Text('${price.toStringAsFixed(2)} €'),
      ]),
    );
  }
}
