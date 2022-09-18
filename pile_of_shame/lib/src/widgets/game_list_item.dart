import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';
import 'package:pile_of_shame/src/models/game_status.dart';
import 'package:pile_of_shame/src/widgets/animated_heart/animated_favourite_button.dart';
import '../models/game.dart';
import '../persistance/storage.dart';
import './age_restriction.dart';

class GameListItem extends StatefulWidget {
  const GameListItem({super.key, required this.game});

  final Game game;

  @override
  State<GameListItem> createState() => _GameListItemState();
}

class _GameListItemState extends State<GameListItem> {
  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = const TextStyle(
      fontSize: 24,
    );
    TextStyle defaultStyle = const TextStyle(
      fontSize: 16,
    );

    final mainPlatform = GamePlatforms.byName(widget.game.platforms.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                      widget.game.title,
                      style: headingStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        widget.game.platforms.join(', '),
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
                        GameStates.gameStateToString(widget.game.gameState),
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
                  AnimatedFavouriteButton(
                      isFilled: widget.game.isFavourite,
                      onPressed: () {
                        setState(() {
                          widget.game.isFavourite = !widget.game.isFavourite;
                          Storage().addOrUpdateGame(widget.game);
                        });
                      }),
                  if (widget.game.price != null)
                    Text(
                      '${widget.game.price!.toStringAsFixed(2)} €',
                      style: defaultStyle,
                    ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                child: AgeRestrictionWidget.fromGame(game: widget.game),
              )
            ],
          ),
        )
      ],
    );
  }
}
