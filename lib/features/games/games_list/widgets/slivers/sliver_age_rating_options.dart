import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

class SliverAgeRatingFilterOptions extends ConsumerWidget {
  const SliverAgeRatingFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageRatingFilter = ref.watch(ageRatingFilterProvider);

    return SliverList.list(
      children: [
        CheckboxListTile(
          title: Text(
            AppLocalizations.of(context)!.ageRating,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          value: ageRatingFilter.length == USK.values.length,
          onChanged: (value) {
            if (value != null) {
              if (value) {
                ref
                    .read(ageRatingFilterProvider.notifier)
                    .setFilter(USK.values);
              } else {
                ref.read(ageRatingFilterProvider.notifier).setFilter([]);
              }
            }
          },
        ),
        ...USK.values.map(
          (ageRating) => CheckboxListTile(
            title: Text(ageRating.toRatedString(context)),
            value: ageRatingFilter.contains(ageRating),
            onChanged: (value) {
              List<USK> filters = List.from(ageRatingFilter);
              if (value != null) {
                if (value) {
                  filters.add(ageRating);
                } else {
                  filters.remove(ageRating);
                }
              }
              ref.read(ageRatingFilterProvider.notifier).setFilter(filters);
            },
          ),
        ),
      ],
    );
  }
}
