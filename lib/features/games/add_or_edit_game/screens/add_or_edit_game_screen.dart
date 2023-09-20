import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/providers/edit_game_provider.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/name_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/notes_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/platform_dropdown.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/price_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/usk_dropdown.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

import '../models/editable_game.dart';
import '../widgets/play_status_dropdown.dart';
import 'add_or_edit_dlc_screen.dart';

class AddGameScreen extends ConsumerStatefulWidget {
  final EditableGame? initialValue;

  const AddGameScreen({super.key, this.initialValue});

  @override
  ConsumerState<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends ConsumerState<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final editableGame = ref.watch(addGameProvider(widget.initialValue));

    return AppScaffold(
      appBar: AppBar(
        title: Text(widget.initialValue == null
            ? AppLocalizations.of(context)!.addGame
            : AppLocalizations.of(context)!.editGame),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPaddingX, vertical: 4.0),
                  child: NameInputField(
                    value: editableGame.name,
                    onChanged: (value) {
                      ref
                          .read(addGameProvider(widget.initialValue).notifier)
                          .updateGame(editableGame.copyWith(name: value));
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: PlatformDropdown(
                    value: editableGame.platform,
                    onChanged: (value) {
                      ref
                          .read(addGameProvider(widget.initialValue).notifier)
                          .updateGame(editableGame.copyWith(platform: value));
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: PlayStatusDropdown(
                    value: editableGame.status,
                    onSelect: (selection) {
                      ref
                          .read(addGameProvider(widget.initialValue).notifier)
                          .updateGame(editableGame.copyWith(status: selection));
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: PriceInputField(
                    value: editableGame.price,
                    onChanged: (value) {
                      ref
                          .read(addGameProvider(widget.initialValue).notifier)
                          .updateGame(editableGame.copyWith(price: value));
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: USKDropdown(
                    onChanged: (value) {
                      ref
                          .read(addGameProvider(widget.initialValue).notifier)
                          .updateGame(editableGame.copyWith(usk: value));
                    },
                    value: editableGame.usk,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPaddingX, vertical: 4.0),
                  child: NotesInputField(
                    value: editableGame.notes,
                    onChanged: (value) {
                      ref
                          .read(addGameProvider(widget.initialValue).notifier)
                          .updateGame(
                            editableGame.copyWith(
                                notes: value.isEmpty ? null : value),
                          );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPaddingX),
                  child: SegmentedActionCard(
                    items: [
                      SegmentedActionCardItem(
                        key: const ValueKey("add_dlc"),
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
                            ref
                                .read(addGameProvider(widget.initialValue)
                                    .notifier)
                                .updateGame(
                                  editableGame.copyWith(
                                    dlcs: [
                                      ...editableGame.dlcs,
                                      result.toDLC()
                                    ],
                                  ),
                                );
                          }
                        },
                      ),
                      ...editableGame.dlcs
                          .asMap()
                          .map(
                            (index, dlc) => MapEntry(
                              index,
                              SegmentedActionCardItem(
                                trailing: IconButton(
                                  onPressed: () async {
                                    final bool? result =
                                        await showAdaptiveDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog.adaptive(
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .deleteDLC),
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .thisActionCannotBeUndone),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .delete,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result != null && result) {
                                      final List<DLC> updatedList =
                                          List.from(editableGame.dlcs);
                                      updatedList.removeAt(index);

                                      ref
                                          .read(
                                            addGameProvider(widget.initialValue)
                                                .notifier,
                                          )
                                          .updateGame(
                                            editableGame.copyWith(
                                              dlcs: updatedList,
                                            ),
                                          );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                leading: const Icon(Icons.edit),
                                title: Text(dlc.name),
                                onTap: () async {
                                  final EditableDLC? update =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddDLCScreen(
                                        initialValue: EditableDLC.fromDLC(dlc),
                                      ),
                                    ),
                                  );

                                  if (update != null) {
                                    final List<DLC> updatedList =
                                        List.from(editableGame.dlcs);
                                    updatedList[index] = update.toDLC();

                                    ref
                                        .read(
                                          addGameProvider(widget.initialValue)
                                              .notifier,
                                        )
                                        .updateGame(
                                          editableGame.copyWith(
                                            dlcs: updatedList,
                                          ),
                                        );
                                  }
                                },
                              ),
                            ),
                          )
                          .values
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
                      key: const ValueKey("save_game"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            editableGame.isValid()) {
                          if (context.mounted) {
                            Navigator.of(context).pop(editableGame);
                          }
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
