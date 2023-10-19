import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class SliverGamePlatformFamilyFilterOptions extends ConsumerWidget {
  const SliverGamePlatformFamilyFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePlatformFamilies =
        ref.watch(activeGamePlatformFamiliesProvider);
    final filters = ref.watch(gameFilterProvider);

    return filters.when(
      data: (filters) => SliverFilters<GamePlatformFamily>(
        title: AppLocalizations.of(context)!.platformFamilies,
        selectedValues: filters.platformFamilies,
        options: activePlatformFamilies.maybeWhen(
          data: (data) => data,
          orElse: () => GamePlatformFamily.values,
        ),
        onSelectAll: (value) {
          if (value) {
            ref.read(gameFilterProvider.notifier).setFilters(
                  filters.copyWith(platformFamilies: GamePlatformFamily.values),
                );
          } else {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(platformFamilies: []));
          }
        },
        optionBuilder: (option, onChanged) => CheckboxListTile(
          title: Text(option.toLocale(AppLocalizations.of(context)!)),
          value: filters.platformFamilies.contains(option),
          onChanged: (value) {
            ref.read(gameFilterProvider.notifier).setFilters(
                  filters.copyWith(platformFamilies: onChanged(value)),
                );
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
