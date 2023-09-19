import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

import 'sliver_filters.dart';

class SliverFavoriteFilterOptions extends ConsumerWidget {
  const SliverFavoriteFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteFilter = ref.watch(favoriteFilterProvider);

    return SliverFilters<bool>(
      title: AppLocalizations.of(context)!.favorites,
      selectedValues: favoriteFilter,
      options: const [true, false],
      onSelectAll: (value) {
        if (value) {
          ref.read(favoriteFilterProvider.notifier).setFilter([true, false]);
        } else {
          ref.read(favoriteFilterProvider.notifier).setFilter([]);
        }
      },
      optionBuilder: (option, onChanged) => CheckboxListTile(
        title: option
            ? Text(AppLocalizations.of(context)!.isFavorite)
            : Text(AppLocalizations.of(context)!.isNotFavorite),
        value: favoriteFilter.contains(option),
        onChanged: (value) {
          ref.read(favoriteFilterProvider.notifier).setFilter(onChanged(value));
        },
      ),
    );
  }
}
