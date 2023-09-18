import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/game_details/screens/game_details_screen.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/customizable_game_display.dart';

class SliverGroupedGames extends ConsumerWidget {
  final String? groupName;
  final List<Game> games;

  const SliverGroupedGames({super.key, this.groupName, required this.games});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Duration entryDuration = 130.ms;
    final hasHeader = (groupName != null && groupName!.isNotEmpty);
    return SliverList.builder(
      itemBuilder: (context, index) {
        int effectiveIndex = hasHeader ? max(index - 1, 0) : index;
        if (hasHeader && index == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              left: defaultPaddingX,
              right: defaultPaddingX,
              top: 16.0,
              bottom: 8.0,
            ),
            child: Text(
              groupName!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        }

        return CustomizableGameDisplay(
          game: games[effectiveIndex],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GameDetailsScreen(
                  gameId: games[effectiveIndex].id,
                ),
              ),
            );
          },
        )
            .animate()
            .fade(
              curve: Curves.easeOut,
              duration: entryDuration,
            )
            .slideX(
              curve: Curves.easeOut,
              duration: entryDuration,
              begin: 0.1,
              end: 0,
            );
      },
      itemCount: hasHeader ? games.length + 1 : games.length,
    );
  }
}
