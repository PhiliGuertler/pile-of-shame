import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

import 'sliver_filters.dart';

class SliverGamePlatformFilterOptions extends ConsumerWidget {
  const SliverGamePlatformFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformFilter = ref.watch(gamePlatformFilterProvider);
    return SliverFilters<GamePlatform>(
      title: AppLocalizations.of(context)!.platform,
      selectedValues: platformFilter,
      options: GamePlatform.values,
      onSelectAll: (value) {
        if (value) {
          ref
              .read(gamePlatformFilterProvider.notifier)
              .setFilter(GamePlatform.values);
        } else {
          ref.read(gamePlatformFilterProvider.notifier).setFilter([]);
        }
      },
      optionBuilder: (option, onChanged) => CheckboxListTile(
        title: Text(option.name),
        value: platformFilter.contains(option),
        onChanged: (value) {
          ref
              .read(gamePlatformFilterProvider.notifier)
              .setFilter(onChanged(value));
        },
      ),
    );
  }
}
