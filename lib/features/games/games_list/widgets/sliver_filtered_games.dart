import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/game_list_tile.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/widgets/error_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';

class SliverFilteredGames extends ConsumerWidget {
  const SliverFilteredGames({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesFilteredProvider);

    final Duration entryDuration = 130.ms;

    return games.when(
      data: (games) => SliverList.builder(
        itemBuilder: (context, index) => GameListTile(game: games.games[index])
            .animate()
            .fade(curve: Curves.easeOut, duration: entryDuration)
            .slideX(
                curve: Curves.easeOut,
                duration: entryDuration,
                begin: 0.1,
                end: 0),
        itemCount: games.games.length,
      ),
      loading: () => SliverList.builder(
        itemBuilder: (context, index) => const SkeletonGameDisplay()
            .animate()
            .fade(curve: Curves.easeOut, duration: entryDuration),
        itemCount: 10,
      ),
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: ErrorDisplay(
          error: error,
          stackTrace: stackTrace,
        ),
      ),
    );
  }
}
