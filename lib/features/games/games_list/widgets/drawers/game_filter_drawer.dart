import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_age_rating_options.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_favorite_options.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_has_dlcs_options.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_has_notes_options.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_platform_family_filter_options.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_platform_filter_options.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_play_status_filter_options.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_filters.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

class GameFilterDrawer extends ConsumerWidget {
  const GameFilterDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnyFilterActive = ref.watch(isAnyFilterActiveProvider);

    return Drawer(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                left: defaultPaddingX,
                right: defaultPaddingX,
                top: 16.0,
                bottom: 16.0,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  AppLocalizations.of(context)!.filterGames,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            isAnyFilterActive.when(
              skipLoadingOnReload: true,
              data: (isAnyFilterActive) => isAnyFilterActive
                  ? SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPaddingX,
                        vertical: 16.0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: Text(
                            AppLocalizations.of(context)!.removeActiveFilters,
                          ),
                          onPressed: () {
                            ref
                                .read(gameFilterProvider.notifier)
                                .setFilters(const GameFilters());
                          },
                        ),
                      ),
                    )
                  : const SliverToBoxAdapter(),
              error: (error, stackTrace) => SliverToBoxAdapter(
                child: Text(error.toString()),
              ),
              loading: () => const SliverToBoxAdapter(),
            ),
            // Favorites
            const SliverFavoriteFilterOptions(),
            // Has Notes
            const SliverHasNotesFilterOptions(),
            // Has DLCs
            const SliverHasDLCsFilterOptions(),
            // PlayStatus
            const SliverPlayStatusFilterOptions(),
            // Platform-Families
            const SliverGamePlatformFamilyFilterOptions(),
            // Platforms
            const SliverGamePlatformFilterOptions(),
            // Age-Rating
            const SliverAgeRatingFilterOptions(),
            // Bottom Padding
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
