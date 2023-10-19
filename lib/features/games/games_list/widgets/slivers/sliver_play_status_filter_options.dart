import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_filters.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class SliverPlayStatusFilterOptions extends ConsumerWidget {
  const SliverPlayStatusFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(gameFilterProvider);

    return filters.when(
      data: (filters) => SliverFilters<PlayStatus>(
        title: AppLocalizations.of(context)!.status,
        selectedValues: filters.playstatuses,
        options: PlayStatus.values,
        onSelectAll: (value) {
          if (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(playstatuses: PlayStatus.values));
          } else {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(playstatuses: []));
          }
        },
        optionBuilder: (option, onChanged) => CheckboxListTile(
          title: Text(option.toLocaleString(AppLocalizations.of(context)!)),
          value: filters.playstatuses.contains(option),
          onChanged: (value) {
            ref
                .read(gameFilterProvider.notifier)
                .setFilters(filters.copyWith(playstatuses: onChanged(value)));
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
