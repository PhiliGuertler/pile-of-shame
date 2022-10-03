import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';
import 'package:pile_of_shame/src/widgets/animated_heart/animated_favourite_button.dart';
import '../../models/game.dart';
import '../../persistance/storage.dart';
import '../age_restriction.dart';
import '../game_cover_view.dart';
import '../game_status_view.dart';

class GameListItem extends StatefulWidget {
  const GameListItem({
    super.key,
    required this.game,
    this.coverOffsetY = 0,
    this.coverScale = 1.0,
  });

  final Game game;
  final double coverOffsetY;
  final double coverScale;

  @override
  State<GameListItem> createState() => _GameListItemState();
}

class _GameListItemState extends State<GameListItem> {
  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = const TextStyle(
      fontSize: 20,
    );
    TextStyle defaultStyle = const TextStyle(
      fontSize: 15,
    );

    final mainPlatform = GamePlatforms.byName(widget.game.platforms.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
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
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Transform.translate(
                  offset: Offset(80 * (widget.coverScale - 1.0) * 0.5,
                      widget.coverOffsetY),
                  child: Transform.scale(
                    scale: widget.coverScale,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: mainPlatform.color.withOpacity(0.9),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2.0)),
                        color: mainPlatform.color.withOpacity(0.9),
                      ),
                      child: Hero(
                        tag: widget.game.title,
                        child: GameCoverView(imageUrl: widget.game.coverImage),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: AnimatedFavouriteButton(
                  isFilled: widget.game.isFavourite,
                  onPressed: () {
                    setState(() {
                      widget.game.isFavourite = !widget.game.isFavourite;
                      Storage().addOrUpdateGame(widget.game);
                    });
                  },
                ),
              ),
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
                    GameStatusView(
                      gameState: widget.game.gameState,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: AgeRestrictionWidget.fromGame(game: widget.game),
                  ),
                  if (widget.game.price != null)
                    Text(
                      '${widget.game.price!.toStringAsFixed(2)} €',
                      style: defaultStyle,
                    ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
