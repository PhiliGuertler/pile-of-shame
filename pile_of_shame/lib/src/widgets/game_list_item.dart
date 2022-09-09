import 'package:flutter/material.dart';
import '../screens/games.dart';
import './age_restriction.dart';

class GameListItem extends StatelessWidget {
  const GameListItem({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = const TextStyle(fontSize: 24);
    TextStyle defaultStyle = const TextStyle(fontSize: 16);

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        game.platform,
                        style: defaultStyle,
                      ),
                      if (game.price != null)
                        Text(
                          '${game.price!.toStringAsFixed(2)} €',
                          style: defaultStyle,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (game.ageRestriction != null)
              Container(
                padding: const EdgeInsets.all(8.0),
                child: AgeRestrictionWidget(game: game),
              )
          ],
        )
      ],
    );
  }
}
