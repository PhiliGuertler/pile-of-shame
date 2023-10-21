import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_grouped_games.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/error_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_header.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_list_summary.dart';

class GamesScreen extends ConsumerWidget {
  final ScrollController scrollController;

  const GamesScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasGames = ref.watch(hasGamesProvider);
    final totalPrice = ref.watch(gamesFilteredTotalPriceProvider);
    final totalGames = ref.watch(gamesFilteredTotalAmountProvider);

    final groupedGames = ref.watch(gamesGroupedProvider);

    return SafeArea(
      child: hasGames.when(
        skipLoadingOnReload: true,
        data: (hasGames) => RefreshIndicator(
          onRefresh: () => ref.refresh(gamesProvider.future),
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: scrollController,
            physics: !hasGames
                ? const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  )
                : null,
            slivers: [
              if (!hasGames)
                const SliverFancyImageHeader(
                  imageAsset: ImageAssets.gamePile,
                  height: 300.0,
                ),
              if (!hasGames)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPaddingX,
                      vertical: 16.0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!
                          .buildYourPileOfShameByAddingNewGames,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (hasGames)
                ...groupedGames.when(
                  skipLoadingOnReload: true,
                  data: (groupedGames) {
                    return groupedGames.entries.map(
                      (group) => SliverGroupedGames(
                        games: group.value,
                        groupName: group.key,
                      ),
                    );
                  },
                  error: (error, stackTrace) => [
                    SliverToBoxAdapter(
                      child: ErrorDisplay(
                        error: error,
                        stackTrace: stackTrace,
                      ),
                    ),
                  ],
                  loading: () => [
                    SliverList.builder(
                      itemBuilder: (context, index) =>
                          const SkeletonGameDisplay()
                              .animate()
                              .fade(curve: Curves.easeOut, duration: 130.ms),
                      itemCount: 10,
                    ),
                  ],
                ),
              if (hasGames)
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  sliver: SliverListSummary(
                    gameCount: totalGames.when(
                      data: (totalGames) => totalGames,
                      loading: () => null,
                      error: (error, stackTrace) => -1,
                    ),
                    totalPrice: totalPrice.when(
                      data: (totalPrice) => totalPrice,
                      loading: () => null,
                      error: (error, stackTrace) => -1,
                    ),
                  ),
                ),
            ],
          ),
        ),
        loading: () => CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverList.builder(
              itemBuilder: (context, index) => const SkeletonGameDisplay(),
              itemCount: 10,
            ),
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
