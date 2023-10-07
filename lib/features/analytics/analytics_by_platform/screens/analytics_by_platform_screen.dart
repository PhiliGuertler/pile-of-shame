import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/widgets/platform_family_analytics_details.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_platform/widgets/platform_analytics_details.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_platform/widgets/sliver_tabs.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_grouped_games.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_header.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_list_summary.dart';

class AnalyticsByPlatformScreen extends ConsumerWidget {
  const AnalyticsByPlatformScreen({super.key, required this.platform});

  final GamePlatform platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final AsyncValue<List<Game>> games =
        ref.watch(gamesByPlatformProvider(platform));

    return AppScaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverFancyImageAppBar(
              borderRadius: -defaultBorderRadius * 2,
              imagePath: platform.controllerLogoPath,
              title: Text(
                platform.localizedName(l10n),
              ),
            ),
            SliverTabs(
              tabs: [
                Tab(
                  child: Text(l10n.analytics),
                ),
                Tab(
                  child: Text(l10n.games),
                ),
              ],
            ),
          ],
          body: TabBarView(
            children: [
              CustomScrollView(
                slivers: [
                  ...games.when(
                    data: (games) => games.isNotEmpty
                        ? [
                            SliverPadding(
                              padding: const EdgeInsets.only(top: 8.0),
                              sliver: SliverAnalyticsPlatformDetails(
                                games: games,
                              ),
                            ),
                          ]
                        : [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPaddingX,
                              ),
                              sliver: SliverFancyImageHeader(
                                imagePath: ImageAssets.gamePile.value,
                                height: 250,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPaddingX,
                                  vertical: 16.0,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .buildYourPileOfShameByAddingNewGamesInTheMainMenu,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
                  ...games.when(
                    skipLoadingOnReload: true,
                    data: (games) {
                      final List<Game> sortedGames = List.from(games);
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
