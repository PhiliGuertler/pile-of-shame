import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

class SliverPlayStatusFilterOptions extends ConsumerWidget {
  const SliverPlayStatusFilterOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playStatusFilter = ref.watch(playStatusFilterProvider);

    return SliverList.list(
      children: [
        CheckboxListTile(
          title: Text(
            AppLocalizations.of(context)!.status,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          value: playStatusFilter.length == PlayStatus.values.length,
          onChanged: (value) {
            if (value != null) {
              if (value) {
                ref
                    .read(playStatusFilterProvider.notifier)
                    .setFilter(PlayStatus.values);
              } else {
                ref.read(playStatusFilterProvider.notifier).setFilter([]);
              }
            }
          },
        ),
        ...PlayStatus.values.map(
          (status) => CheckboxListTile(
            title: Text(status.toLocaleString(context)),
            value: playStatusFilter.contains(status),
            onChanged: (value) {
              List<PlayStatus> filters = List.from(playStatusFilter);
              if (value != null) {
                if (value) {
                  filters.add(status);
                } else {
                  filters.remove(status);
                }
              }
              ref.read(playStatusFilterProvider.notifier).setFilter(filters);
            },
          ),
        ),
      ],
    );
  }
}
