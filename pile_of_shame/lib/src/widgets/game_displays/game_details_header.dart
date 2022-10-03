import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';
import 'package:pile_of_shame/src/widgets/animated_heart/animated_favourite_button.dart';
import '../../models/game.dart';
import '../../persistance/storage.dart';
import '../game_cover_view.dart';
import '../game_status_view.dart';

class GameDetailsHeader extends StatefulWidget {
  const GameDetailsHeader({
    super.key,
    required this.game,
    this.coverOffsetY = 0,
    this.coverScale = 1.0,
  });

  final Game game;
  final double coverOffsetY;
  final double coverScale;

  @override
  State<GameDetailsHeader> createState() => _GameDetailsHeaderState();
}

class _GameDetailsHeaderState extends State<GameDetailsHeader> {
  @override
  Widget build(BuildContext context) {
    final mainPlatform = GamePlatforms.byName(widget.game.platforms.first);

    const double imageWidth = 80.0;
    const double imageHeight = imageWidth * 4 / 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            right: 8.0,
            top: 8.0,
            bottom: 8.0,
          ),
          decoration: BoxDecoration(
            gradient: RadialGradient(
                center: const Alignment(
                  -1.0,
                  15.0,
                ),
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
                padding: EdgeInsets.only(
                    right: 8.0 + imageWidth * (widget.coverScale - 1.0),
                    left: 8.0),
                child: Transform.translate(
                  offset: Offset(
                    imageWidth * (widget.coverScale - 1.0) * 0.5,
                    widget.coverOffsetY,
                  ),
                  child: Transform.scale(
                    scale: widget.coverScale,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: mainPlatform.color.withOpacity(0.9),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(2.0),
                        ),
                        color: mainPlatform.color.withOpacity(0.9),
                      ),
                      width: imageWidth,
                      height: imageHeight,
                      child: Hero(
                        tag: widget.game.title,
                        child: GameCoverView(imageUrl: widget.game.coverImage),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedFavouriteButton(
                      isFilled: widget.game.isFavourite,
                      onPressed: () {
                        setState(() {
                          widget.game.isFavourite = !widget.game.isFavourite;
                          Storage().addOrUpdateGame(widget.game);
                        });
                      },
                    ),
                    GameStatusView(
                      gameState: widget.game.gameState,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
