import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/screens/games.dart';

class GameListItem extends StatelessWidget {
  const GameListItem({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(game.title),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(game.platform),
            if (game.price != null) Text('${game.price!.toStringAsFixed(2)} €'),
          ],
        )
      ],
    );
  }
}
