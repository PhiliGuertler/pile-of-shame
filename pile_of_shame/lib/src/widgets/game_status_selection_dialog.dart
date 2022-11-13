import 'package:flutter/material.dart';

import '../models/game_status.dart';
import 'game_status_simple_dialog_item.dart';

class GameStatusSelectionDialog extends StatelessWidget {
  const GameStatusSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Status aktualisieren"),
      children: [
        GameStatusSimpleDialogItem(
          gameState: GameState.none,
          onPressed: () {
            Navigator.pop(context, GameState.none);
          },
        ),
        GameStatusSimpleDialogItem(
          gameState: GameState.onWishList,
          onPressed: () {
            Navigator.pop(context, GameState.onWishList);
          },
        ),
        GameStatusSimpleDialogItem(
          gameState: GameState.onPileOfShame,
          onPressed: () {
            Navigator.pop(context, GameState.onPileOfShame);
          },
        ),
        GameStatusSimpleDialogItem(
          gameState: GameState.currentlyPlaying,
          onPressed: () {
            Navigator.pop(context, GameState.currentlyPlaying);
          },
        ),
        GameStatusSimpleDialogItem(
          gameState: GameState.cancelled,
          onPressed: () {
            Navigator.pop(context, GameState.cancelled);
          },
        ),
        GameStatusSimpleDialogItem(
          gameState: GameState.unfinishable,
          onPressed: () {
            Navigator.pop(context, GameState.unfinishable);
          },
        ),
        GameStatusSimpleDialogItem(
          gameState: GameState.completed,
          onPressed: () {
            Navigator.pop(context, GameState.completed);
          },
        ),
        GameStatusSimpleDialogItem(
          gameState: GameState.completed100Percent,
          onPressed: () {
            Navigator.pop(context, GameState.completed100Percent);
          },
        ),
      ],
    );
    ;
  }
}
