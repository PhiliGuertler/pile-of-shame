import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class PlatformsScreen extends ConsumerWidget {
  const PlatformsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamePlatforms = ref.watch(gamePlatformsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.yourPlatforms),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPaddingX, vertical: 8.0),
              child: Text(AppLocalizations.of(context)!
                  .selectWhichGamePlatformsYouHaveOnlyEnabledPlatformsAreSelectableWhenAddingAndEditingGamesAlsoOnlyEnabledPlatformsCanBeUsedAsFiltersGamesFromDisabledPlatformsAreStillVisibleWhenNoPlatformFiltersAreActive),
            ),
          ),
          gamePlatforms.when(
            data: (gamePlatforms) => SliverList.builder(
              itemBuilder: (context, index) {
                final platform = GamePlatform.values[index];
                final isContained = gamePlatforms.contains(platform);
                return SwitchListTile.adaptive(
                  value: isContained,
                  title: Text(platform.name),
                  onChanged: (value) {
                    List<GamePlatform> update = List.from(gamePlatforms);
                    if (value) {
                      update.add(platform);
                    } else {
                      update.remove(platform);
                    }
                    ref
                        .read(gamePlatformsProvider.notifier)
                        .updatePlatforms(update);
                  },
                );
              },
              itemCount: GamePlatform.values.length,
            ),
            loading: () => SliverList.list(
              children: [
                for (int i = 0; i < 15; ++i) const ListTileSkeleton(),
              ],
            ),
            error: (error, stackTrace) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(defaultPaddingX),
                child: Text(
                  error.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
