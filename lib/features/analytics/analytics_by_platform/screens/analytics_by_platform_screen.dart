import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/widgets/sliver_analytics_details.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_grouped_games.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_list_summary.dart';

class AnalyticsByPlatformScreen extends ConsumerWidget {
  const AnalyticsByPlatformScreen({super.key, required this.platform});

  final GamePlatform platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final AsyncValue<Database> analyticsDatabase =
        ref.watch(databaseByPlatformProvider(platform));

    return AppScaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomNestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverFancyImageAppBar(
              imagePath: platform.controllerLogoPath,
              title: Text(
                platform.localizedName(l10n),
              ),
              bottom: TabBar(
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Text(l10n.analytics),
                  ),
                  Tab(
                    child: Text(l10n.games),
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              CustomScrollView(
                slivers: [
                  ...analyticsDatabase.when(
                    data: (database) => [
                      SliverAnalyticsDetails(
                        games: database.games,
                        hardware: database.hardware,
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 32.0),
                      ),
                    ],
                    error: (error, stackTrace) => [
                      SliverToBoxAdapter(
                        child: Text(error.toString()),
                      ),
                    ],
                    loading: () => [const SliverAnalyticsDetailsSkeleton()],
                  ),
                ],
              ),
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: defaultPaddingX,
                        right: defaultPaddingX,
                        top: 16.0,
                      ),
                      child: Text(
                        l10n.games,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  ...analyticsDatabase.when(
                    skipLoadingOnReload: true,
                    data: (databse) {
                      final List<Game> sortedGames = List.from(databse.games);
                      sortedGames.sort(
                        (a, b) =>
                            SortStrategy.byName.sorter.compareGames(a, b, true),
                      );
                      return [
                        SliverGroupedGames(games: sortedGames),
                        SliverListSummary(
                          gameCount: sortedGames.length,
                          totalPrice: sortedGames.fold<double>(
                            0.0,
                            (previousValue, element) =>
                                element.fullPrice() + previousValue,
                          ),
                        ),
                      ];
                    },
                    loading: () => [
                      SliverList.builder(
                        itemBuilder: (context, index) =>
                            const SkeletonGameDisplay().animate().fade(
                                  curve: Curves.easeOut,
                                  duration: 130.ms,
                                ),
                        itemCount: 10,
                      ),
                    ],
                    error: (error, stackTrace) => [
                      SliverToBoxAdapter(
                        child: Text(error.toString()),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
