import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/customizable_game_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class GameDisplayScreen extends ConsumerWidget {
  const GameDisplayScreen({super.key});

  Stream<Game> randomizeGame() async* {
    int platformIndex = 0;
    int statusIndex = 0;
    int uskIndex = 0;

    while (true) {
      yield Game(
        id: "game-preview",
        name: "Outer Wilds",
        platform: GamePlatform.values[platformIndex],
        status: PlayStatus.values[statusIndex],
        usk: USK.values[uskIndex],
        price: 29.99,
        lastModified: DateTime(2023, 9, 24),
      );

      await Future.delayed(const Duration(seconds: 4));

      platformIndex = (platformIndex + 1) % GamePlatform.values.length;
      statusIndex = (statusIndex + 1) % PlayStatus.values.length;
      uskIndex = (uskIndex + 1) % USK.values.length;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(customizeGameDisplaysProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gameDisplay),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: Text(
                  AppLocalizations.of(context)!.preview,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.red)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: StreamBuilder<Game>(
                      stream: randomizeGame(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CustomizableGameDisplay(
                            game: snapshot.data!,
                            onTap: () {
                              // Don't do anything here
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: Text(
                  AppLocalizations.of(context)!.settings,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          settings.when(
            data: (settings) => SliverList.list(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: DropdownButtonFormField<GameDisplayLeading>(
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.leftArea),
                      suffixIcon: const Icon(Icons.expand_more),
                      prefixIcon: const Icon(Icons.arrow_back),
                    ),
                    onChanged: (value) async {
                      if (value != null) {
                        ref
                            .read(customizeGameDisplaysProvider.notifier)
                            .setCustomGameDisplay(
                              settings.copyWith(leading: value),
                            );
                      }
                    },
                    // Display the text of selected items only, as the prefix-icon takes care of the logo
                    selectedItemBuilder: (context) => GameDisplayLeading.values
                        .map((l) => Text(l.toLocaleString(context)))
                        .toList(),
                    // Don't display the default icon, instead display nothing
                    icon: const SizedBox(),
                    value: settings.leading,
                    items: GameDisplayLeading.values
                        .map(
                          (l) => DropdownMenuItem<GameDisplayLeading>(
                            value: l,
                            child: Text(
                              l.toLocaleString(context),
                              key: ValueKey(l.toString()),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: DropdownButtonFormField<GameDisplayTrailing>(
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.rightArea),
                      suffixIcon: const Icon(Icons.expand_more),
                      prefixIcon: const Icon(Icons.arrow_forward),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(customizeGameDisplaysProvider.notifier)
                            .setCustomGameDisplay(
                              settings.copyWith(trailing: value),
                            );
                      }
                    },
                    // Display the text of selected items only, as the prefix-icon takes care of the logo
                    selectedItemBuilder: (context) => GameDisplayTrailing.values
                        .map((l) => Text(l.toLocaleString(context)))
                        .toList(),
                    // Don't display the default icon, instead display nothing
                    icon: const SizedBox(),
                    value: settings.trailing,
                    items: GameDisplayTrailing.values
                        .map(
                          (l) => DropdownMenuItem<GameDisplayTrailing>(
                            value: l,
                            child: Text(
                              l.toLocaleString(context),
                              key: ValueKey(l.toString()),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: DropdownButtonFormField<GameDisplaySecondary>(
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.bottomArea),
                      suffixIcon: const Icon(Icons.expand_more),
                      prefixIcon: const Icon(Icons.arrow_downward),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(customizeGameDisplaysProvider.notifier)
                            .setCustomGameDisplay(
                              settings.copyWith(secondary: value),
                            );
                      }
                    },
                    // Display the text of selected items only, as the prefix-icon takes care of the logo
                    selectedItemBuilder: (context) => GameDisplaySecondary
                        .values
                        .map((l) => Text(l.toLocaleString(context)))
                        .toList(),
                    // Don't display the default icon, instead display nothing
                    icon: const SizedBox(),
                    value: settings.secondary,
                    items: GameDisplaySecondary.values
                        .map(
                          (l) => DropdownMenuItem<GameDisplaySecondary>(
                            value: l,
                            child: Text(
                              l.toLocaleString(context),
                              key: ValueKey(l.toString()),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                CheckboxListTile(
                  title: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 16.0),
                        child: Icon(Icons.animation),
                      ),
                      Text(AppLocalizations.of(context)!.fancyAnimations),
                    ],
                  ),
                  value: settings.hasFancyAnimations,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(customizeGameDisplaysProvider.notifier)
                          .setCustomGameDisplay(
                              settings.copyWith(hasFancyAnimations: value));
                    }
                  },
                ),
                CheckboxListTile(
                  title: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 16.0),
                        child: Icon(Icons.repeat),
                      ),
                      Text(AppLocalizations.of(context)!.repeatAnimations),
                    ],
                  ),
                  enabled: settings.hasFancyAnimations,
                  value: settings.hasRepeatingAnimations,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(customizeGameDisplaysProvider.notifier)
                          .setCustomGameDisplay(
                              settings.copyWith(hasRepeatingAnimations: value));
                    }
                  },
                ),
              ],
            ),
            loading: () => SliverList.list(
              children: const [
                SkeletonGameDisplay(),
                ListTileSkeleton(),
                ListTileSkeleton(),
                ListTileSkeleton(),
                ListTileSkeleton(),
              ],
            ),
            error: (error, stackTrace) => SliverList.list(
              children: [Text(error.toString())],
            ),
          ),
        ],
      ),
    );
  }
}
