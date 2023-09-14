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

class GameDisplayScreen extends ConsumerWidget {
  const GameDisplayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(customizeGameDisplaysProvider);

    final Game exampleGame = Game(
      id: "example-game",
      name: "Outer Wilds",
      platform: GamePlatform.playStation4,
      status: PlayStatus.completed100Percent,
      lastModified: DateTime(2023, 9, 4),
      price: 29.99,
      usk: USK.usk16,
    );

    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gameDisplay),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 48.0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.red)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomizableGameDisplay(
                      game: exampleGame,
                      onTap: () {
                        // Don't do anything here
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          settings.when(
            data: (settings) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPaddingX),
              sliver: SliverList.list(children: [
                DropdownButtonFormField<GameDisplayLeading>(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.leftArea),
                    suffixIcon: const Icon(Icons.expand_more),
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
                DropdownButtonFormField<GameDisplayTrailing>(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.rightArea),
                    suffixIcon: const Icon(Icons.expand_more),
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
                DropdownButtonFormField<GameDisplaySecondary>(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.bottomArea),
                    suffixIcon: const Icon(Icons.expand_more),
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
                  selectedItemBuilder: (context) => GameDisplaySecondary.values
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
              ]),
            ),
            loading: () => SliverList.list(
              children: const [
                Text("Loading..."),
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
