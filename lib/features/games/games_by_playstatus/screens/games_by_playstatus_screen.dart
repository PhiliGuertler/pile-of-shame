import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/providers/games_by_playstatus_providers.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_grouped_games.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_by.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_order.dart';
import 'package:pile_of_shame/features/root_page/root_games/widgets/root_games_fab.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_list_summary.dart';

class GamesByPlaystatusScreen extends ConsumerStatefulWidget {
  GamesByPlaystatusScreen({super.key, required this.playStatuses})
      : assert(playStatuses.isNotEmpty);

  final List<PlayStatus> playStatuses;

  @override
  ConsumerState<GamesByPlaystatusScreen> createState() =>
      _GamesByPlaystatusScreenState();
}

class _GamesByPlaystatusScreenState
    extends ConsumerState<GamesByPlaystatusScreen> {
  late ScrollController _scrollController;
  bool isScrolled = false;

  ImageAssets playStatusToAsset(PlayStatus status) {
    switch (status) {
      case PlayStatus.playing:
      case PlayStatus.replaying:
      case PlayStatus.endlessGame:
        return ImageAssets.controllerUnknown;
      case PlayStatus.onPileOfShame:
        return ImageAssets.gamePile;
      case PlayStatus.onWishList:
        return ImageAssets.list;
      case PlayStatus.cancelled:
        return ImageAssets.deadGame;
      case PlayStatus.completed:
      case PlayStatus.completed100Percent:
        return ImageAssets.barChart;
    }
  }

  void handleScroll() {
    final offset = _scrollController.offset;
    final minScrollExtent = _scrollController.position.minScrollExtent;
    final bool result = offset > minScrollExtent;
    setState(() {
      isScrolled = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final games =
        ref.watch(gamesByPlayStatusesSortedProvider(widget.playStatuses));
    final sorter =
        ref.watch(gameSortingByPlayStatusProvider(widget.playStatuses.first));

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
                          widget.playStatuses.first,
                          sorting.copyWith(sortStrategy: value),
                        );
                  },
                ),
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverSortOrder(
                  isAscending: sorting.isAscending,
                  onChanged: (value) {
                    ref
                        .read(gamesByPlayStatusSorterProvider.notifier)
                        .setSorting(
                          widget.playStatuses.first,
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
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFancyImageAppBar(
            title: Text(widget.playStatuses.first.toLocaleString(l10n)),
            imagePath: playStatusToAsset(widget.playStatuses.first).value,
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
          ...games.when(
            skipLoadingOnReload: true,
            data: (games) {
              return [
                SliverGroupedGames(games: games),
                SliverListSummary(
                  gameCount: games.length,
                  totalPrice: games.fold(
                    0.0,
                    (previousValue, element) =>
                        element.fullPrice() + previousValue!,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 48.0),
                ),
              ];
            },
            error: (error, stackTrace) =>
                [SliverToBoxAdapter(child: Text(error.toString()))],
            loading: () => [
              SliverList.builder(
                itemBuilder: (context, index) => const SkeletonGameDisplay(),
                itemCount: 10,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: RootGamesFab(
        isExtended: !isScrolled,
        initialPlayStatus: widget.playStatuses.first,
      ),
    );
  }
}
