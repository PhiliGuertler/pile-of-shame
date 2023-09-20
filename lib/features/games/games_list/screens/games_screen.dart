import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_grouped_games.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/error_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_header.dart';

import '../widgets/sliver_filter_by_family.dart';

class GamesScreen extends ConsumerWidget {
  final ScrollController scrollController;

  const GamesScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasGames = ref.watch(hasGamesProvider);
    final totalPrice = ref.watch(gamesFilteredTotalPriceProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
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
                    imagePath: 'assets/misc/game_pile.webp', height: 300.0),
              if (!hasGames)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPaddingX, vertical: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!
                          .buildYourPileOfShameByAddingNewGames,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (hasGames) const SliverContractSorterFilter(),
              if (hasGames)
                ...groupedGames.when(
                  skipLoadingOnReload: true,
                  data: (groupedGames) {
                    return groupedGames.entries
                        .map((group) => SliverGroupedGames(
                              games: group.value,
                              groupName: group.key,
                            ));
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: defaultPaddingX,
                      right: defaultPaddingX,
                      bottom: 80.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 128,
                          child: totalGames.when(
                            data: (totalGames) => Text(
                                AppLocalizations.of(context)!
                                    .nGames(totalGames)),
                            loading: () => const Skeleton(
                              widthFactor: 1,
                            ),
                            error: (error, stackTrace) =>
                                Text(error.toString()),
                          ),
                        ),
                        SizedBox(
                          width: 128,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: totalPrice.when(
                              data: (totalPrice) =>
                                  Text(currencyFormatter.format(totalPrice)),
                              loading: () => const Skeleton(
                                widthFactor: 1,
                                alignment: Alignment.centerRight,
                              ),
                              error: (error, stackTrace) =>
                                  Text(error.toString()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
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
