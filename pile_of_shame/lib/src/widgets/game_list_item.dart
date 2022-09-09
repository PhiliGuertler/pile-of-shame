import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/screens/games.dart';

class GameListItem extends StatelessWidget {
  const GameListItem({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = TextStyle(fontSize: 24);
    TextStyle defaultStyle = TextStyle(fontSize: 16);

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
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: game.getAgeRestictionColor(),
                      child: Text(game.getAgeRestrictionText(),
                          style: TextStyle(
                              color: game
                                          .getAgeRestictionColor()
                                          .computeLuminance() >
                                      0.5
                                  ? Colors.black
                                  : Colors.white))))
          ],
        )
      ],
    );
  }
}
