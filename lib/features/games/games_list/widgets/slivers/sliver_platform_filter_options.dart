import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

class SliverGamePlatformFilterOptions extends ConsumerWidget {
  const SliverGamePlatformFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformFilter = ref.watch(gamePlatformFilterProvider);

    return SliverList.list(
      children: [
        CheckboxListTile(
          title: Text(
            AppLocalizations.of(context)!.platform,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          value: platformFilter.length == GamePlatform.values.length,
          onChanged: (value) {
            if (value != null) {
              if (value) {
                ref
                    .read(gamePlatformFilterProvider.notifier)
                    .setFilter(GamePlatform.values);
              } else {
                ref.read(gamePlatformFilterProvider.notifier).setFilter([]);
              }
            }
          },
        ),
        ...GamePlatform.values.map(
          (platform) => CheckboxListTile(
            title: Text(platform.name),
            value: platformFilter.contains(platform),
            onChanged: (value) {
              List<GamePlatform> filters = List.from(platformFilter);
              if (value != null) {
                if (value) {
                  filters.add(platform);
                } else {
                  filters.remove(platform);
                }
              }
              ref.read(gamePlatformFilterProvider.notifier).setFilter(filters);
            },
          ),
        ),
      ],
    );
  }
}
