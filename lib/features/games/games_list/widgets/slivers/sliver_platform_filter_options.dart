import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class SliverGamePlatformFilterOptions extends ConsumerWidget {
  const SliverGamePlatformFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(gameFilterProvider);

    final allPlatforms = ref.watch(activeGamePlatformsProvider);

    final allPlatformValues = allPlatforms.maybeWhen(
      data: (data) => data,
      orElse: () => GamePlatform.values,
    );

    return filters.when(
      data: (filters) => SliverFilters<GamePlatform>(
        title: AppLocalizations.of(context)!.platform,
        selectedValues: filters.platforms,
        options: allPlatformValues,
        onSelectAll: (value) {
          if (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(platforms: GamePlatform.values));
          } else {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(platforms: []));
          }
        },
        optionBuilder: (option, onChanged) => CheckboxListTile(
          title: Text(option.localizedName(AppLocalizations.of(context)!)),
          value: filters.platforms.contains(option),
          onChanged: (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(platforms: onChanged(value)));
          },
        ),
      ),
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: Text(error.toString()),
      ),
      loading: () => const SliverToBoxAdapter(
        child: ListTileSkeleton(),
      ),
    );
  }
}
