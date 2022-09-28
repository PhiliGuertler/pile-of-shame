import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_status.dart';
import 'package:pile_of_shame/src/widgets/animated_sparkle/animated_sparkling_controller.dart';

class GameStatusView extends StatelessWidget {
  const GameStatusView({super.key, required this.gameState});

  final GameState gameState;

  double gameStateToProgress(GameState state) {
    switch (state) {
      case GameState.currentlyPlaying:
        return 0.8;
      case GameState.onPileOfShame:
        return 0.6;
      case GameState.onWishList:
        return 0.3;
      case GameState.cancelled:
      case GameState.completed:
      case GameState.completed100Percent:
      default:
        return 1.0;
    }
  }

  Color gameStateToColor(GameState state) {
    switch (state) {
      case GameState.currentlyPlaying:
        return Colors.orange;
      case GameState.completed:
        return Colors.green.shade400;
      case GameState.completed100Percent:
        return Colors.green.shade600;
      case GameState.cancelled:
        return Colors.red;
      case GameState.onPileOfShame:
        return Colors.deepOrange;
      case GameState.onWishList:
        return Colors.blue;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress = gameStateToProgress(gameState);

    Widget content = Container(
      width: 180,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              gameStateToColor(gameState),
              gameStateToColor(gameState),
              Colors.black,
              Colors.black,
            ],
            stops: [
              0,
              progress,
              progress,
              1
            ]),
      ),
      child: Text(
        GameStates.gameStateToString(gameState),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    if (gameState == GameState.completed100Percent) {
      return AnimatedSparklingController(
        numSparks: 5,
        child: content,
      );
    }

    return content;
  }
}
