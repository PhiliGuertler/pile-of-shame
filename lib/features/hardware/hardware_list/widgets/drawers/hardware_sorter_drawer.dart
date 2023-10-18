import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_sort_games_order.dart';
import 'package:pile_of_shame/features/hardware/hardware_list/widgets/slivers/sliver_sort_hardware_by.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/hardware_sorting.dart';
import 'package:pile_of_shame/providers/hardware/hardware_sorter_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';

class HardwareSorterDrawer extends ConsumerWidget {
  const HardwareSorterDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorting = ref.watch(sortHardwareProvider);

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
                  AppLocalizations.of(context)!.sortHardware,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            ...sorting.when(
              data: (sorting) => [
                SliverSortHardwareBy(
                  activeStrategy: sorting.sortStrategy,
                  onChanged: (value) {
                    ref.read(sortHardwareProvider.notifier).setSorting(
                          sorting.copyWith(sortStrategy: value),
                        );
                  },
                ),
                SliverSortOrder(
                  isAscending: sorting.isAscending,
                  onChanged: (value) {
                    ref
                        .read(sortHardwareProvider.notifier)
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
                  itemCount: SortStrategyHardware.values.length,
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
