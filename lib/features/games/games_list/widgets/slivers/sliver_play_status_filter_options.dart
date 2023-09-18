import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

import 'sliver_filters.dart';

class SliverPlayStatusFilterOptions extends ConsumerWidget {
  const SliverPlayStatusFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playStatusFilter = ref.watch(playStatusFilterProvider);

    return SliverFilters<PlayStatus>(
      title: AppLocalizations.of(context)!.status,
      selectedValues: playStatusFilter,
      options: PlayStatus.values,
      onSelectAll: (value) {
        if (value) {
          ref
              .read(playStatusFilterProvider.notifier)
              .setFilter(PlayStatus.values);
        } else {
          ref.read(playStatusFilterProvider.notifier).setFilter([]);
        }
      },
      optionBuilder: (option, onChanged) => CheckboxListTile(
        title: Text(option.toLocaleString(AppLocalizations.of(context)!)),
        value: playStatusFilter.contains(option),
        onChanged: (value) {
          ref
              .read(playStatusFilterProvider.notifier)
              .setFilter(onChanged(value));
        },
      ),
    );
  }
}
