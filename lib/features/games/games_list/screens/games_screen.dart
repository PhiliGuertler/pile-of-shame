import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/widgets/error_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

import '../widgets/game_list_tile.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);

    return SafeArea(
      child: games.when(
        data: (games) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(gamesProvider.future),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                ...games
                    .map(
                      (game) => SliverToBoxAdapter(
                        child: GameListTile(game: game),
                      ),
                    )
                    .toList(),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48.0,
                  ),
                ),
              ],
            ).animate().fadeIn(),
          );
        },
        error: (error, stackTrace) => ErrorDisplay(
          error: error,
          stackTrace: stackTrace,
        ).animate().fadeIn(),
        loading: () => CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            for (int i = 0; i < 10; ++i)
              const SliverToBoxAdapter(
                child: ListTileSkeleton(
                  hasSubtitle: true,
                ),
              ),
          ],
        ).animate().fadeIn(),
      ),
    );
  }
}
