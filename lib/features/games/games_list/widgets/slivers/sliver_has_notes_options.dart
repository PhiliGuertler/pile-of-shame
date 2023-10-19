import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class SliverHasNotesFilterOptions extends ConsumerWidget {
  const SliverHasNotesFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(gameFilterProvider);

    return filters.when(
      data: (filters) => SliverFilters<bool>(
        title: AppLocalizations.of(context)!.notes,
        selectedValues: filters.hasNotes,
        options: const [true, false],
        onSelectAll: (value) {
          if (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(hasNotes: [true, false]));
          } else {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(hasNotes: []));
          }
        },
        optionBuilder: (option, onChanged) => CheckboxListTile(
          title: option
              ? Text(AppLocalizations.of(context)!.hasNotes)
              : Text(AppLocalizations.of(context)!.hasNoNotes),
          value: filters.hasNotes.contains(option),
          onChanged: (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(hasNotes: onChanged(value)));
          },
        ),
      ),
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: Text(error.toString()),
      ),
      loading: () => const SliverToBoxAdapter(
        child: ListTileSkeleton(),
      ),
    );
  }
}
