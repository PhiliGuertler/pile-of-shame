import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/widgets/game_list_item.dart';

import '../models/game.dart';

class GameDetails extends StatelessWidget {
  const GameDetails({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          GameListItem(game: game),
        ]),
      ),
    );
  }
}
