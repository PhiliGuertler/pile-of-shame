import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  SegmentedActionCardItem dlcToItem(
      BuildContext context, DLC dlc, int index, EditableGame editableGame) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedActionCardItem(
      trailing: IconButton(
        onPressed: () async {
          final bool? result = await showAdaptiveDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: Text(l10n.deleteDLC),
              content: Text(l10n.thisActionCannotBeUndone),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    l10n.delete,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          );

          if (result != null && result) {
            final List<DLC> updatedList = List.from(editableGame.dlcs);
            updatedList.removeAt(index);

            ref
                .read(
                  addGameProvider(widget.initialValue).notifier,
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
        final EditableDLC? update = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddDLCScreen(
              initialValue: EditableDLC.fromDLC(dlc),
            ),
          ),
        );

        if (update != null) {
          final List<DLC> updatedList = List.from(editableGame.dlcs);
          updatedList[index] = update.toDLC();

          ref
              .read(
                addGameProvider(widget.initialValue).notifier,
              )
              .updateGame(
                editableGame.copyWith(
                  dlcs: updatedList,
                ),
              );
        }
      },
    );
  }

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
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: PriceInputField(
                            enabled: !editableGame.wasGifted,
                            value: editableGame.price,
                            onChanged: (value) {
                              ref
                                  .read(addGameProvider(widget.initialValue)
                                      .notifier)
                                  .updateGame(
                                      editableGame.copyWith(price: value));
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final newValue = !editableGame.wasGifted;
                            ref
                                .read(addGameProvider(widget.initialValue)
                                    .notifier)
                                .updateGame(editableGame.copyWith(
                                  wasGifted: newValue,
                                ));
                          },
                          child: SizedBox(
                            width: 80.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.cake_sharp,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                                    .animate(
                                        target: editableGame.wasGifted ? 0 : 1)
                                    .shake()
                                    .scale(
                                        begin: const Offset(1.0, 1.0),
                                        end: const Offset(1.2, 1.2),
                                        curve: Curves.easeInOutBack)
                                    .then()
                                    .swap(
                                      builder: (context, child) =>
                                          const Icon(Icons.cake_outlined)
                                              .animate()
                                              .scale(
                                                begin: const Offset(1.2, 1.2),
                                                end: const Offset(1.0, 1.0),
                                                curve: Curves.easeInOutBack,
                                              ),
                                    ),
                                Text(
                                  AppLocalizations.of(context)!.gift,
                                  style: editableGame.wasGifted
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                              dlcToItem(context, dlc, index, editableGame),
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
