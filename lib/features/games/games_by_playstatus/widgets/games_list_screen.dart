import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_grouped_games.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_by.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_order.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_list_summary.dart';

class GamesListScreen extends ConsumerWidget {
  const GamesListScreen({
    super.key,
    required this.sortedGames,
    required this.sorter,
    required this.onOrderChanged,
    required this.onStrategyChanged,
    required this.imageAsset,
    required this.title,
    this.floatingActionButton,
    this.scrollController,
  });

  final AsyncValue<List<Game>> sortedGames;
  final AsyncValue<GameSorting> sorter;
  final void Function(GameSorting previousValue, bool isAscending)
      onOrderChanged;
  final void Function(GameSorting previousValue, SortStrategy strategy)
      onStrategyChanged;
  final ImageAssets imageAsset;
  final String title;
  final Widget? floatingActionButton;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    onStrategyChanged(sorting, value);
                  },
                ),
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverSortOrder(
                  isAscending: sorting.isAscending,
                  onChanged: (value) {
                    onOrderChanged(sorting, value);
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
        controller: scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFancyImageAppBar(
            title: Text(title),
            imageAsset: imageAsset,
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
          ...sortedGames.when(
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
      floatingActionButton: floatingActionButton,
    );
  }
}
