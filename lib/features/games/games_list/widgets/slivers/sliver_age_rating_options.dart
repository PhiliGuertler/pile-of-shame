import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class SliverAgeRatingFilterOptions extends ConsumerWidget {
  const SliverAgeRatingFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(gameFilterProvider);

    return filters.when(
      data: (filters) => SliverFilters<USK>(
        title: AppLocalizations.of(context)!.ageRating,
        selectedValues: filters.ageRatings,
        options: USK.values,
        onSelectAll: (value) {
          if (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(ageRatings: USK.values));
          } else {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(ageRatings: []));
          }
        },
        optionBuilder: (option, onChanged) => CheckboxListTile(
          title: Text(option.toRatedString(AppLocalizations.of(context)!)),
          value: filters.ageRatings.contains(option),
          onChanged: (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(ageRatings: onChanged(value)));
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
