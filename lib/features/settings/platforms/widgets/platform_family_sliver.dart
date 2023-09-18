import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class PlatformFamilySliver extends ConsumerWidget {
  final GamePlatformFamily family;

  const PlatformFamilySliver({super.key, required this.family});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullSelection = ref.watch(gamePlatformsByFamilyProvider);
    final selection = ref.watch(activeGamePlatformsByFamilyProvider);

    assert(fullSelection.containsKey(family));
    final List<GamePlatform> fullPlatforms = fullSelection[family]!;

    return selection.when(
      skipLoadingOnReload: true,
      data: (selection) {
        return SliverList.builder(
          itemBuilder: (context, index) {
            int effectiveIndex = index;
            List<GamePlatform> selectedPlatforms = selection[family] ?? [];
            if (index == 0) {
              // Display a listtile for the whole family
              return Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: SwitchListTile.adaptive(
                  title: Text(
                    family.toLocale(AppLocalizations.of(context)!),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  value: selectedPlatforms.isNotEmpty,
                  onChanged: (value) async {
                    final currentActivePlatforms =
                        await ref.read(activeGamePlatformsProvider.future);
                    List<GamePlatform> update = List.of(currentActivePlatforms);
                    if (value) {
                      update.addAll(fullPlatforms);
                      update = update.toSet().toList();
                    } else {
                      update.removeWhere(
                        (element) => element.family == family,
                      );
                    }
                    ref
                        .read(activeGamePlatformsProvider.notifier)
                        .updatePlatforms(update);
                  },
                ),
              );
            } else {
              // Display a list tile for the platform
              effectiveIndex = effectiveIndex - 1;
              GamePlatform platform = fullPlatforms[effectiveIndex];
              return SwitchListTile.adaptive(
                title: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GamePlatformIcon(platform: platform),
                  ),
                  Expanded(
                    child: Text(
                      platform.localizedName(AppLocalizations.of(context)!),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
                value: selectedPlatforms.contains(platform),
                onChanged: (value) async {
                  final currentActivePlatforms =
                      await ref.read(activeGamePlatformsProvider.future);
                  final update = List.of(currentActivePlatforms);
                  if (value) {
                    update.add(platform);
                  } else {
                    update.remove(platform);
                  }
                  ref
                      .read(activeGamePlatformsProvider.notifier)
                      .updatePlatforms(update);
                },
              );
            }
          },
          itemCount: fullPlatforms.length + 1,
        );
      },
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: Text(error.toString()),
      ),
      loading: () {
        return SliverList.list(children: [
          for (int i = 0; i < fullSelection.length + 1; ++i)
            const ListTileSkeleton(),
        ]);
      },
    );
  }
}
