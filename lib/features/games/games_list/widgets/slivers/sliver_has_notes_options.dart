import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

import 'sliver_filters.dart';

class SliverHasNotesFilterOptions extends ConsumerWidget {
  const SliverHasNotesFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasNotesFilter = ref.watch(hasNotesFilterProvider);

    return SliverFilters<bool>(
      title: AppLocalizations.of(context)!.notes,
      selectedValues: hasNotesFilter,
      options: const [true, false],
      onSelectAll: (value) {
        if (value) {
          ref.read(hasNotesFilterProvider.notifier).setFilter([true, false]);
        } else {
          ref.read(hasNotesFilterProvider.notifier).setFilter([]);
        }
      },
      optionBuilder: (option, onChanged) => CheckboxListTile(
        title: option
            ? Text(AppLocalizations.of(context)!.hasNotes)
            : Text(AppLocalizations.of(context)!.hasNoNotes),
        value: hasNotesFilter.contains(option),
        onChanged: (value) {
          ref.read(hasNotesFilterProvider.notifier).setFilter(onChanged(value));
        },
      ),
    );
  }
}
