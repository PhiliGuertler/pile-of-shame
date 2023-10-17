import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/widgets/platform_family_analytics_details.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_platform/screens/analytics_by_platform_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/utils/grouper_utils.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/image_list_tile.dart';
import 'package:pile_of_shame/widgets/responsiveness/responsive_wrap.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_header.dart';

class AnalyticsByFamiliesScreen extends ConsumerWidget {
  const AnalyticsByFamiliesScreen({super.key, this.family});

  final GamePlatformFamily? family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final AsyncValue<Database> analyticsDatabase =
        ref.watch(databaseByPlatformFamilyProvider(family));

    return AppScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFancyImageAppBar(
            imagePath: family?.image.value ?? ImageAssets.library.value,
            title: Text(
              family != null ? family!.toLocale(l10n) : l10n.gameLibrary,
            ),
          ),
          ...analyticsDatabase.when(
            data: (database) =>
                database.games.isNotEmpty && database.hardware.isNotEmpty
                    ? [
                        SliverPlatformFamilyAnalyticsDetails(
                          games: database.games,
                          hardware: database.hardware,
                          hasFamilyDistributionChart: family == null,
                        ),
                      ]
                    : [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPaddingX,
                          ),
                          sliver: SliverOpacity(
                            opacity: 0.7,
                            sliver: SliverFancyImageHeader(
                              imagePath: ImageAssets.pieChart.value,
                              height: 250,
                            ),
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
                                  .addGamesToGenerateALibraryAnalysis,
                              style: Theme.of(context).textTheme.headlineSmall,
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
          ...analyticsDatabase.when(
            data: (database) {
              final groups = GameGrouperUtils(l10n: l10n).groupAndSortGames(
                database.games,
                GroupStrategy.byPlatform,
                const GameSorting(),
              );

              return [
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  sliver: SliverToBoxAdapter(
                    child: ResponsiveWrap(
                      children: groups.entries.map((group) {
                        final GamePlatform platform =
                            GamePlatform.values.firstWhere(
                          (element) =>
                              element.localizedAbbreviation(l10n) == group.key,
                        );
                        return ImageListTile(
                          imagePath: platform.controllerLogoPath,
                          heroTag: group.key,
                          title: Text(platform.localizedName(l10n)),
                          subtitle: Text(l10n.nGames(group.value.length)),
                          openBuilderOnTap: (context, action) =>
                              AnalyticsByPlatformScreen(platform: platform),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ];
            },
            error: (error, stackTrace) => [
              SliverToBoxAdapter(
                child: Text(error.toString()),
              ),
            ],
            loading: () => [const SliverAnalyticsDetailsSkeleton()],
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 48.0),
          ),
        ],
      ),
    );
  }
}
