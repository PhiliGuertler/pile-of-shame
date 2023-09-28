import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

class SliverAgeRatingFilterOptions extends ConsumerWidget {
  const SliverAgeRatingFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageRatingFilter = ref.watch(ageRatingFilterProvider);

    return SliverFilters<USK>(
      title: AppLocalizations.of(context)!.ageRating,
      selectedValues: ageRatingFilter,
      options: USK.values,
      onSelectAll: (value) {
        if (value) {
          ref.read(ageRatingFilterProvider.notifier).setFilter(USK.values);
        } else {
          ref.read(ageRatingFilterProvider.notifier).setFilter([]);
        }
      },
      optionBuilder: (option, onChanged) => CheckboxListTile(
        title: Text(option.toRatedString(AppLocalizations.of(context)!)),
        value: ageRatingFilter.contains(option),
        onChanged: (value) {
          ref
              .read(ageRatingFilterProvider.notifier)
              .setFilter(onChanged(value));
        },
      ),
    );
  }
}
