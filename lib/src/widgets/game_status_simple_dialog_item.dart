import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_status.dart';
import 'package:pile_of_shame/src/widgets/game_status_view.dart';

class GameStatusSimpleDialogItem extends StatelessWidget {
  const GameStatusSimpleDialogItem(
      {super.key, required this.gameState, required this.onPressed});

  final GameState gameState;
  final VoidCallback onPressed;

  static const double imageWidth = 60.0;
  static const double imageHeight = imageWidth * 4 / 3;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: GameStatusView(gameState: gameState),
    );
  }
}
