import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/settings/platforms/widgets/platform_family_sliver.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

class PlatformsScreen extends ConsumerWidget {
  const PlatformsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullSelection = ref.watch(gamePlatformsByFamilyProvider);

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
          ...fullSelection.entries
              .map((e) => PlatformFamilySliver(family: e.key))
              .toList(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16.0)),
        ],
      ),
    );
  }
}
