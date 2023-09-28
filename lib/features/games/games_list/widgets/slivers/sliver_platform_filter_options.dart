import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';

class SliverGamePlatformFilterOptions extends ConsumerWidget {
  const SliverGamePlatformFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformFilter = ref.watch(gamePlatformFilterProvider);
    final allPlatforms = ref.watch(activeGamePlatformsProvider);

    final allPlatformValues = allPlatforms.maybeWhen(
      data: (data) => data,
      orElse: () => GamePlatform.values,
    );

    return SliverFilters<GamePlatform>(
      title: AppLocalizations.of(context)!.platform,
      selectedValues: platformFilter,
      options: allPlatformValues,
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
        title: Text(option.localizedName(AppLocalizations.of(context)!)),
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
