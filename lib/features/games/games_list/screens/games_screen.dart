import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/sliver_filtered_games.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/widgets/error_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';

import '../widgets/sliver_filter_by_family.dart';

class GamesScreen extends ConsumerWidget {
  final ScrollController scrollController;

  const GamesScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasGames = ref.watch(hasGamesProvider);

    return SafeArea(
      child: hasGames.when(
        data: (hasGames) => RefreshIndicator(
          onRefresh: () => ref.refresh(gamesProvider.future),
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: const [
              SliverContractSorterFilter(),
              SliverFilteredGames(),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48.0,
                ),
              ),
            ],
          ),
        ),
        loading: () => CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            const SliverContractSorterFilterSkeleton(),
            SliverList.builder(
              itemBuilder: (context, index) => const SkeletonGameDisplay(),
              itemCount: 10,
            )
          ],
        ).animate().fadeIn(),
        error: (error, stackTrace) => ErrorDisplay(
          error: error,
          stackTrace: stackTrace,
        ).animate().fadeIn(),
      ),
    );
  }
}
