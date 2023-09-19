import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

import 'sliver_filters.dart';

class SliverHasDLCsFilterOptions extends ConsumerWidget {
  const SliverHasDLCsFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDLCsFilter = ref.watch(hasDLCsFilterProvider);

    return SliverFilters<bool>(
      title: AppLocalizations.of(context)!.dlcs,
      selectedValues: hasDLCsFilter,
      options: const [true, false],
      onSelectAll: (value) {
        if (value) {
          ref.read(hasDLCsFilterProvider.notifier).setFilter([true, false]);
        } else {
          ref.read(hasDLCsFilterProvider.notifier).setFilter([]);
        }
      },
      optionBuilder: (option, onChanged) => CheckboxListTile(
        title: option
            ? Text(AppLocalizations.of(context)!.hasDLCs)
            : Text(AppLocalizations.of(context)!.hasNoDLCs),
        value: hasDLCsFilter.contains(option),
        onChanged: (value) {
          ref.read(hasDLCsFilterProvider.notifier).setFilter(onChanged(value));
        },
      ),
    );
  }
}
