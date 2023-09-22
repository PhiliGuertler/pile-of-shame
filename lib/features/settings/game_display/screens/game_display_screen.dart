import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/draggable_game_display_leading_trailing.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/draggable_game_display_secondary.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/age_rating_text_display.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/customizable_game_display.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/last_modified_display.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/price_and_last_modified_display.dart';
import 'package:pile_of_shame/widgets/price_only_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

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
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final exampleGame = Game(
      id: "game-preview",
      name: "Outer Wilds",
      platform: GamePlatform.steam,
      status: PlayStatus.playing,
      usk: USK.usk12,
      price: 29.99,
      lastModified: DateTime(2023, 9, 24),
    );

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
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX, vertical: 16.0),
            sliver: SliverList.list(children: [
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  DraggableGameDisplayLeadingTrailing(
                    value: GameDisplayLeadingTrailing.ageRatingIcon,
                    child: USKLogo.fromGame(game: exampleGame),
                  ),
                  DraggableGameDisplayLeadingTrailing(
                    value: GameDisplayLeadingTrailing.platformIcon,
                    child: GamePlatformIcon.fromGame(game: exampleGame),
                  ),
                  DraggableGameDisplayLeadingTrailing(
                    value: GameDisplayLeadingTrailing.playStatusIcon,
                    child: PlayStatusIcon.fromGame(game: exampleGame),
                  ),
                  DraggableGameDisplayLeadingTrailing(
                    width: 75.0,
                    value: GameDisplayLeadingTrailing.priceAndLastModified,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: PriceAndLastModifiedDisplay.fromGame(
                        game: exampleGame,
                      ),
                    ),
                  ),
                  DraggableGameDisplayLeadingTrailing(
                    width: 75.0,
                    value: GameDisplayLeadingTrailing.priceOnly,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: PriceOnlyDisplay.fromGame(
                        game: exampleGame,
                      ),
                    ),
                  ),
                  DraggableGameDisplayLeadingTrailing(
                    width: 75.0,
                    value: GameDisplayLeadingTrailing.lastModifiedOnly,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: LastModifiedDisplay.fromGame(
                        game: exampleGame,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX, vertical: 16.0),
            sliver: SliverList.list(children: [
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  DraggableGameDisplaySecondary(
                    value: GameDisplaySecondary.ageRatingText,
                    child: AgeRatingTextDisplay.fromGame(
                      game: exampleGame,
                    ),
                  ),
                  DraggableGameDisplaySecondary(
                    value: GameDisplaySecondary.statusText,
                    child: PlayStatusDisplay.fromGame(
                      game: exampleGame,
                    ),
                  ),
                  DraggableGameDisplaySecondary(
                    value: GameDisplaySecondary.platformText,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        exampleGame.platform
                            .localizedName(AppLocalizations.of(context)!),
                      ),
                    ),
                  ),
                  DraggableGameDisplaySecondary(
                    value: GameDisplaySecondary.price,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                          currencyFormatter.format(exampleGame.fullPrice())),
                    ),
                  ),
                ],
              ),
            ]),
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
                  child: DropdownButtonFormField<GameDisplayLeadingTrailing>(
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
                    selectedItemBuilder: (context) => GameDisplayLeadingTrailing
                        .values
                        .map((l) => Text(l.toLocaleString(context)))
                        .toList(),
                    // Don't display the default icon, instead display nothing
                    icon: const SizedBox(),
                    value: settings.leading,
                    items: GameDisplayLeadingTrailing.values
                        .map(
                          (l) => DropdownMenuItem<GameDisplayLeadingTrailing>(
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
                  child: DropdownButtonFormField<GameDisplayLeadingTrailing>(
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
                    selectedItemBuilder: (context) => GameDisplayLeadingTrailing
                        .values
                        .map((l) => Text(l.toLocaleString(context)))
                        .toList(),
                    // Don't display the default icon, instead display nothing
                    icon: const SizedBox(),
                    value: settings.trailing,
                    items: GameDisplayLeadingTrailing.values
                        .map(
                          (l) => DropdownMenuItem<GameDisplayLeadingTrailing>(
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
