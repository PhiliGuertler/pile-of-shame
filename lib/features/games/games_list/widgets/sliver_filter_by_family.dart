import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';

class SliverContractSorterFilter extends ConsumerWidget {
  const SliverContractSorterFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(gamePlatformFamilyFilterProvider);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                  selected:
                      activeFilters.length == GamePlatformFamily.values.length,
                  label: Text(AppLocalizations.of(context)!.all),
                  onSelected: (value) {
                    if (value) {
                      ref
                          .read(gamePlatformFamilyFilterProvider.notifier)
                          .setFilter(GamePlatformFamily.values);
                    } else {
                      ref
                          .read(gamePlatformFamilyFilterProvider.notifier)
                          .setFilter([]);
                    }
                  }),
            ),
            ...GamePlatformFamily.values.map(
              (filter) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  selected: activeFilters.contains(filter),
                  label: Text(filter.name),
                  onSelected: (value) {
                    final List<GamePlatformFamily> updatedFilters =
                        List.from(activeFilters);
                    if (value) {
                      updatedFilters.add(filter);
                    } else {
                      updatedFilters.remove(filter);
                    }
                    ref
                        .read(gamePlatformFamilyFilterProvider.notifier)
                        .setFilter(updatedFilters);
                  },
                ),
              ),
            ),
            const SizedBox(width: 4.0),
          ],
        ),
      ),
    );
  }
}

class SliverContractSorterFilterSkeleton extends StatelessWidget {
  static const double chipHeights = 36.0;

  const SliverContractSorterFilterSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            SizedBox(width: 4.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                  width: 130.0,
                  child: Skeleton(
                    height: chipHeights,
                    widthFactor: 1,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                  width: 80.0,
                  child: Skeleton(
                    height: chipHeights,
                    widthFactor: 1,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                  width: 120.0,
                  child: Skeleton(
                    height: chipHeights,
                    widthFactor: 1,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                  width: 90.0,
                  child: Skeleton(
                    height: chipHeights,
                    widthFactor: 1,
                  )),
            ),
            SizedBox(width: 4.0),
          ],
        ),
      ),
    );
  }
}
