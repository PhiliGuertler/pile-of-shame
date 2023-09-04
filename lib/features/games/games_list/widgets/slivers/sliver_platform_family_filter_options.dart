import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

class SliverGamePlatformFamilyFilterOptions extends ConsumerWidget {
  const SliverGamePlatformFamilyFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformFamilyFilter = ref.watch(gamePlatformFamilyFilterProvider);

    return SliverList.list(
      children: [
        CheckboxListTile(
          title: Text(
            AppLocalizations.of(context)!.platformFamilies,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          value:
              platformFamilyFilter.length == GamePlatformFamily.values.length,
          onChanged: (value) {
            if (value != null) {
              if (value) {
                ref
                    .read(gamePlatformFamilyFilterProvider.notifier)
                    .setFilter(GamePlatformFamily.values);
              } else {
                ref
                    .read(gamePlatformFamilyFilterProvider.notifier)
                    .setFilter([]);
              }
            }
          },
        ),
        ...GamePlatformFamily.values.map(
          (family) => CheckboxListTile(
            title: Text(family.toLocale(context)),
            value: platformFamilyFilter.contains(family),
            onChanged: (value) {
              List<GamePlatformFamily> filters =
                  List.from(platformFamilyFilter);
              if (value != null) {
                if (value) {
                  filters.add(family);
                } else {
                  filters.remove(family);
                }
              }
              ref
                  .read(gamePlatformFamilyFilterProvider.notifier)
                  .setFilter(filters);
            },
          ),
        ),
      ],
    );
  }
}
