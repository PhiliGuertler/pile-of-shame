import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/providers/games_by_playstatus_providers.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_grouped_games.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_by.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_order.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';

class GamesByPlaystatusScreen extends ConsumerWidget {
  GamesByPlaystatusScreen({super.key, required this.playStatuses})
      : assert(playStatuses.isNotEmpty);

  final List<PlayStatus> playStatuses;

  ImageAssets playStatusToAsset(PlayStatus status) {
    switch (status) {
      case PlayStatus.playing:
      case PlayStatus.replaying:
      case PlayStatus.endlessGame:
        return ImageAssets.pc;
      case PlayStatus.onPileOfShame:
        return ImageAssets.gamePile;
      case PlayStatus.onWishList:
        return ImageAssets.list;
      case PlayStatus.cancelled:
        return ImageAssets.deadGame;
      case PlayStatus.completed:
      case PlayStatus.completed100Percent:
        return ImageAssets.library;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final games = ref.watch(gamesByPlayStatusesSortedProvider(playStatuses));
    final sorter =
        ref.watch(gameSortingByPlayStatusProvider(playStatuses.first));

    return AppScaffold(
      drawer: Drawer(
        child: sorter.when(
          skipLoadingOnReload: true,
          data: (sorting) => SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                    vertical: 16.0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      AppLocalizations.of(context)!.sortGames,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                SliverSortGamesBy(
                  activeStrategy: sorting.sortStrategy,
                  onChanged: (value) {
                    ref
                        .read(gamesByPlayStatusSorterProvider.notifier)
                        .setSorting(
                          playStatuses.first,
                          sorting.copyWith(sortStrategy: value),
                        );
                  },
                ),
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverSortGamesOrder(
                  isAscending: sorting.isAscending,
                  onChanged: (value) {
                    ref
                        .read(gamesByPlayStatusSorterProvider.notifier)
                        .setSorting(
                          playStatuses.first,
                          sorting.copyWith(isAscending: value),
                        );
                  },
                ),
              ],
            ),
          ),
          loading: () => Container(),
          error: (error, stackTrace) => Text(error.toString()),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFancyImageAppBar(
            title: Text(playStatuses.first.toLocaleString(l10n)),
            imagePath: playStatusToAsset(playStatuses.first).value,
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.sort),
                  );
                },
              ),
            ],
          ),
          games.when(
            skipLoadingOnReload: true,
            data: (games) {
              return SliverGroupedGames(games: games);
            },
            error: (error, stackTrace) =>
                SliverToBoxAdapter(child: Text(error.toString())),
            loading: () => SliverList.builder(
              itemBuilder: (context, index) => const SkeletonGameDisplay(),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
