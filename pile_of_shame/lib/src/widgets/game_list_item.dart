import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';
import 'package:pile_of_shame/src/models/game_status.dart';
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

    final mainPlatform = GamePlatforms.byName(game.platforms.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                  center: const Alignment(-1.0, 15.0),
                  radius: 10.0,
                  colors: [
                    mainPlatform.color.withOpacity(0.9),
                    mainPlatform.color.withOpacity(0.05),
                  ]),
            ),
            child: Row(
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          game.platforms.join(', '),
                          style: defaultStyle,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: const [
                              0.0,
                              1.0,
                            ],
                            colors: [
                              mainPlatform.color.withOpacity(0.8),
                              mainPlatform.color.withOpacity(0.4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          GameStates.gameStateToString(game.gameState),
                          style: TextStyle(
                            color: mainPlatform.color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                  child: AgeRestrictionWidget.fromGame(game: game),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
