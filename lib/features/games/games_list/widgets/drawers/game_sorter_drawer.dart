import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';

class GameSorterDrawer extends ConsumerWidget {
  const GameSorterDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorting = ref.watch(sortGamesProvider);

    return Drawer(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                  left: defaultPaddingX,
                  right: defaultPaddingX,
                  top: 16.0,
                  bottom: 16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  AppLocalizations.of(context)!.sortGames,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            ...sorting.when(
              data: (sorting) => [
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final SortStrategy strategy = SortStrategy.values[index];
                    return CheckboxListTile(
                      value: sorting.sortStrategy == strategy,
                      title: Text(strategy.toLocaleString(context)),
                      onChanged: (value) {
                        ref.read(sortGamesProvider.notifier).setSorting(
                            sorting.copyWith(sortStrategy: strategy));
                      },
                    );
                  },
                  itemCount: SortStrategy.values.length,
                ),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(
                  child: CheckboxListTile(
                    title: Text(AppLocalizations.of(context)!.isAscending),
                    value: sorting.isAscending,
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(sortGamesProvider.notifier)
                            .setSorting(sorting.copyWith(isAscending: value));
                      }
                    },
                  ),
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
          ],
        ),
      ),
    );
  }
}
