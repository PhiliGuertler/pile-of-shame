import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class SliverHasDLCsFilterOptions extends ConsumerWidget {
  const SliverHasDLCsFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(gameFilterProvider);

    return filters.when(
      data: (filters) => SliverFilters<bool>(
        title: AppLocalizations.of(context)!.dlcs,
        selectedValues: filters.hasDLCs,
        options: const [true, false],
        onSelectAll: (value) {
          if (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(hasDLCs: [true, false]));
          } else {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(hasDLCs: []));
          }
        },
        optionBuilder: (option, onChanged) => CheckboxListTile(
          title: option
              ? Text(AppLocalizations.of(context)!.hasDLCs)
              : Text(AppLocalizations.of(context)!.hasNoDLCs),
          value: filters.hasDLCs.contains(option),
          onChanged: (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(hasDLCs: onChanged(value)));
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
