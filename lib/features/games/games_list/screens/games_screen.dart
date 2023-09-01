import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/sliver_filtered_games.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/error_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';

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

    return SafeArea(
      child: hasGames.when(
        data: (hasGames) => RefreshIndicator(
          onRefresh: () => ref.refresh(gamesProvider.future),
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              const SliverContractSorterFilter(),
              const SliverFilteredGames(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0,
                      left: defaultPaddingX,
                      right: defaultPaddingX,
                      bottom: 80.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.nGames(totalGames)),
                      Text(currencyFormatter.format(totalPrice)),
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
