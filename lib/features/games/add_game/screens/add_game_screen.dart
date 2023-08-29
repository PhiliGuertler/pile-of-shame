import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_game/providers/add_game_provider.dart';
import 'package:pile_of_shame/features/games/add_game/widgets/game_platform_input_field.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/utils/validators.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/input/dropdown_search_field.dart';
import 'package:pile_of_shame/widgets/input/number_input_field.dart';
import 'package:pile_of_shame/widgets/input/text_input_field.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

import '../models/editable_game.dart';
import 'add_dlc_screen.dart';

class AddGameScreen extends ConsumerWidget {
  const AddGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editableGame = ref.watch(addGameProvider);

    final List<GamePlatform> sortedGamePlatforms =
        List.from(GamePlatform.values);
    sortedGamePlatforms.sort(
      (a, b) => a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addGame),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Cancel this process
              throw UnimplementedError();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX, vertical: 4.0),
                child: TextInputField(
                  label: Text('${AppLocalizations.of(context)!.name}*'),
                  textInputAction: TextInputAction.next,
                  initialValue: editableGame.name ?? '',
                  onChanged: (value) {
                    ref
                        .read(addGameProvider.notifier)
                        .updateGame(editableGame.copyWith(name: value));
                  },
                  validator: Validators.validateFieldIsRequired(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: DropdownSearchField<GamePlatform>(
                  value: editableGame.platform,
                  filter: (searchTerm, option) {
                    // check if the platform family is matching
                    final matchesFamily =
                        option.family.name.toLowerCase().contains(searchTerm);

                    // check if the platform's abbreviation contains all the search terms
                    final matchesAbbreviation =
                        option.abbreviation.toLowerCase().contains(searchTerm);
                    // check if the platform's name conains all the search terms
                    final matchesName =
                        option.name.toLowerCase().contains(searchTerm);

                    return matchesFamily || matchesAbbreviation || matchesName;
                  },
                  optionBuilder: (context, option, onTap) => ListTile(
                    leading: GamePlatformIcon(platform: option),
                    title: Text(option.name),
                    onTap: onTap,
                  ),
                  valueBuilder: (context, option, onTap) =>
                      GamePlatformInputField(
                    value: option,
                    label: Text("${AppLocalizations.of(context)!.platform}*"),
                    onTap: onTap,
                  ),
                  options: sortedGamePlatforms,
                  onChanged: (value) {
                    ref
                        .read(addGameProvider.notifier)
                        .updateGame(editableGame.copyWith(platform: value));
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: DropdownButtonFormField<PlayStatus>(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.status),
                    suffixIcon: const Icon(Icons.expand_more),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(addGameProvider.notifier)
                          .updateGame(editableGame.copyWith(status: value));
                    }
                  },
                  // Display the text of selected items only, as the prefix-icon takes care of the logo
                  selectedItemBuilder: (context) => PlayStatus.values
                      .map((status) => Text(status.toLocaleString(context)))
                      .toList(),
                  // Don't display the default icon, instead display nothing
                  icon: const SizedBox(),
                  value: editableGame.status,
                  items: PlayStatus.values
                      .map(
                        (status) => DropdownMenuItem<PlayStatus>(
                          value: status,
                          child: Text(status.toLocaleString(context)),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: NumberInputField(
                  label: Text(AppLocalizations.of(context)!.price),
                  textInputAction: TextInputAction.next,
                  initialValue: editableGame.price,
                  onChanged: (value) {
                    ref
                        .read(addGameProvider.notifier)
                        .updateGame(editableGame.copyWith(price: value));
                  },
                  isCurrency: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: DropdownButtonFormField<USK>(
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.ageRating),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: USKLogo(ageRestriction: editableGame.usk),
                    ),
                    suffixIcon: const Icon(Icons.expand_more),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(addGameProvider.notifier)
                          .updateGame(editableGame.copyWith(usk: value));
                    }
                  },
                  // Display the text of selected items only, as the prefix-icon takes care of the logo
                  selectedItemBuilder: (context) => USK.values
                      .map((usk) => Text(usk.toRatedString(context)))
                      .toList(),
                  // Don't display the default icon, instead display nothing
                  icon: const SizedBox(),
                  value: editableGame.usk,
                  items: USK.values
                      .map(
                        (usk) => DropdownMenuItem<USK>(
                          value: usk,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: USKLogo(ageRestriction: usk),
                              ),
                              Text(usk.toRatedString(context)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPaddingX),
                child: SegmentedActionCard(
                  items: [
                    SegmentedActionCardItem(
                      leading: const Icon(Icons.add),
                      title: Text(AppLocalizations.of(context)!.addDLC),
                      onTap: () async {
                        final EditableDLC? result =
                            await Navigator.of(context).push<EditableDLC?>(
                          MaterialPageRoute(
                            builder: (context) => const AddDLCScreen(),
                          ),
                        );

                        if (result != null) {
                          ref.read(addGameProvider.notifier).updateGame(
                              editableGame.copyWith(
                                  dlcs: [...editableGame.dlcs, result]));
                        }
                      },
                    ),
                    ...editableGame.dlcs
                        .map(
                          (e) => SegmentedActionCardItem(
                            leading: const Icon(Icons.edit),
                            title: Text(e.name ?? '???'),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPaddingX,
                  vertical: defaultPaddingX,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement saving
                      throw UnimplementedError();
                    },
                    child: Text(AppLocalizations.of(context)!.save),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
