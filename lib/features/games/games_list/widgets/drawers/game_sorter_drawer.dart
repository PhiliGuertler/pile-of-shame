import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_by.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_order.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/providers/games/game_group_provider.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

class GameSorterDrawer extends ConsumerWidget {
  const GameSorterDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorting = ref.watch(sortGamesProvider);
    final grouping = ref.watch(groupGamesProvider);

    return Drawer(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                left: defaultPaddingX,
                right: defaultPaddingX,
                top: 16.0,
                bottom: 16.0,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  AppLocalizations.of(context)!.sortGames,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            ...sorting.when(
              data: (sorting) => [
                SliverSortGamesBy(
                  activeStrategy: sorting.sortStrategy,
                  onChanged: (value) {
                    ref.read(sortGamesProvider.notifier).setSorting(
                          sorting.copyWith(sortStrategy: value),
                        );
                  },
                ),
                SliverSortOrder(
                  isAscending: sorting.isAscending,
                  onChanged: (value) {
                    ref
                        .read(sortGamesProvider.notifier)
                        .setSorting(sorting.copyWith(isAscending: value));
                  },
                ),
              ],
              error: (error, stackTrace) => [
                SliverToBoxAdapter(
                  child: Text(
                    error.toString(),
                  ),
                ),
              ],
              loading: () => [
                SliverList.builder(
                  itemBuilder: (context, index) => const Skeleton(),
                  itemCount: SortStrategy.values.length,
                ),
              ],
            ),
            const SliverToBoxAdapter(child: Divider()),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: defaultPaddingX,
                right: defaultPaddingX,
                top: 16.0,
                bottom: 16.0,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  AppLocalizations.of(context)!.groupGames,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            ...grouping.when(
              data: (grouping) => [
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final GroupStrategy strategy = GroupStrategy.values[index];
                    return RadioListTile.adaptive(
                      groupValue: grouping.groupStrategy,
                      value: strategy,
                      title: Text(
                        strategy.toLocaleString(AppLocalizations.of(context)!),
                      ),
                      onChanged: (value) {
                        ref.read(groupGamesProvider.notifier).setGrouping(
                              grouping.copyWith(groupStrategy: strategy),
                            );
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    );
                  },
                  itemCount: GroupStrategy.values.length,
                ),
              ],
              error: (error, stackTrace) => [
                SliverToBoxAdapter(
                  child: Text(
                    error.toString(),
                  ),
                ),
              ],
              loading: () => [
                SliverList.builder(
                  itemBuilder: (context, index) => const Skeleton(),
                  itemCount: SortStrategy.values.length,
                ),
              ],
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 16.0)),
          ],
        ),
      ),
    );
  }
}
