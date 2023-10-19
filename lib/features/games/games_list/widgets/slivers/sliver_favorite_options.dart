import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class SliverFavoriteFilterOptions extends ConsumerWidget {
  const SliverFavoriteFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(gameFilterProvider);

    return filters.when(
      data: (filters) => SliverFilters<bool>(
        title: AppLocalizations.of(context)!.favorites,
        selectedValues: filters.isFavorite,
        options: const [true, false],
        onSelectAll: (value) {
          if (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(isFavorite: [true, false]));
          } else {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(isFavorite: []));
          }
        },
        optionBuilder: (option, onChanged) => CheckboxListTile(
          title: option
              ? Text(AppLocalizations.of(context)!.isFavorite)
              : Text(AppLocalizations.of(context)!.isNotFavorite),
          value: filters.isFavorite.contains(option),
          onChanged: (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(isFavorite: onChanged(value)));
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
