import 'package:flutter/material.dart';
import '../models/game.dart';
import './age_restriction.dart';

class GameListItem extends StatelessWidget {
  const GameListItem({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = const TextStyle(
      fontSize: 24,
    );
    TextStyle defaultStyle = const TextStyle(
      fontSize: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: headingStyle,
                  ),
                  Text(
                    game.platform,
                    style: defaultStyle,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (game.isFavourite)
                  const Icon(Icons.favorite, color: Colors.red),
                if (!game.isFavourite) const Icon(Icons.favorite_outline),
                if (game.price != null)
                  Text(
                    '${game.price!.toStringAsFixed(2)} €',
                    style: defaultStyle,
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: AgeRestrictionWidget(game: game),
            )
          ],
        )
      ],
    );
  }
}
