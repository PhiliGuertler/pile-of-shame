import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/game_platform_analytics.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/game_platform_family_analytics.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/play_status_analytics.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_header.dart';

class AnalyticsRootContentScreen extends ConsumerStatefulWidget {
  const AnalyticsRootContentScreen({super.key});

  @override
  ConsumerState<AnalyticsRootContentScreen> createState() =>
      _AnalyticsRootContentScreenState();
}

class _AnalyticsRootContentScreenState
    extends ConsumerState<AnalyticsRootContentScreen> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final hasGames = ref.watch(hasGamesProvider);
    return SafeArea(
      child: hasGames.when(
        skipLoadingOnReload: true,
        loading: () => const CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: Skeleton(),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingX),
          child: Text(error.toString()),
        ),
        data: (data) => data
            ? const TabBarView(
                children: [
                  GamePlatformFamilyAnalytics(),
                  GamePlatformAnalytics(),
                  PlayStatusAnalytics(),
                ],
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(gamesProvider.future),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    const SliverFancyImageHeader(
                      imagePath: 'assets/misc/pie_chart.webp',
                      height: 300.0,
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
                ),
              ),
      ),
    );
  }
}
