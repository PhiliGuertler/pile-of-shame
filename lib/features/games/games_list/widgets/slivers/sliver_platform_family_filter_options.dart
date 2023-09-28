import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';

class SliverGamePlatformFamilyFilterOptions extends ConsumerWidget {
  const SliverGamePlatformFamilyFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePlatformFamilies =
        ref.watch(activeGamePlatformFamiliesProvider);
    final platformFamilyFilter = ref.watch(gamePlatformFamilyFilterProvider);
    return SliverFilters<GamePlatformFamily>(
      title: AppLocalizations.of(context)!.platformFamilies,
      selectedValues: platformFamilyFilter,
      options: activePlatformFamilies.maybeWhen(
        data: (data) => data,
        orElse: () => GamePlatformFamily.values,
      ),
      onSelectAll: (value) {
        if (value) {
          ref
              .read(gamePlatformFamilyFilterProvider.notifier)
              .setFilter(GamePlatformFamily.values);
        } else {
          ref.read(gamePlatformFamilyFilterProvider.notifier).setFilter([]);
        }
      },
      optionBuilder: (option, onChanged) => CheckboxListTile(
        title: Text(option.toLocale(AppLocalizations.of(context)!)),
        value: platformFamilyFilter.contains(option),
        onChanged: (value) {
          ref
              .read(gamePlatformFamilyFilterProvider.notifier)
              .setFilter(onChanged(value));
        },
      ),
    );
  }
}
