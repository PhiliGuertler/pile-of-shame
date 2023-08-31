import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/widgets/error_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';

import '../widgets/game_list_tile.dart';

class GamesScreen extends ConsumerWidget {
  final ScrollController scrollController;

  const GamesScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);

    return SafeArea(
      child: games.when(
        data: (games) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(gamesProvider.future),
            child: CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList.builder(
                  itemBuilder: (context, index) =>
                      GameListTile(game: games.games[index]),
                  itemCount: games.games.length,
                ),
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
            SliverList.builder(
              itemBuilder: (context, index) => const SkeletonGameDisplay(),
              itemCount: 10,
            ),
          ],
        ).animate().fadeIn(),
      ),
    );
  }
}
