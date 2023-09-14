import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/game_details/screens/game_details_screen.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/widgets/customizable_game_display.dart';

class GameListTile extends ConsumerWidget {
  final Game game;

  const GameListTile({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomizableGameDisplay(
      game: game,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameDetailsScreen(
              gameId: game.id,
            ),
          ),
        );
      },
    );
  }
}
