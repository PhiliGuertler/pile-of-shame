import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/providers/edit_game_provider.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/screens/add_or_edit_dlc_screen.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/name_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/notes_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/platform_dropdown.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/play_status_dropdown.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/price_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/price_variant_dropdown.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/usk_dropdown.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/models/price_variant.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

class AddGameScreen extends ConsumerStatefulWidget {
  final EditableGame? initialValue;
  final PlayStatus? initialPlayStatus;

  const AddGameScreen({super.key, this.initialValue, this.initialPlayStatus});

  @override
  ConsumerState<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends ConsumerState<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();

  SegmentedActionCardItem dlcToItem(
    BuildContext context,
    DLC dlc,
    int index,
    EditableGame editableGame,
  ) {
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
                  addGameProvider(widget.initialValue, widget.initialPlayStatus)
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
                addGameProvider(widget.initialValue, widget.initialPlayStatus)
                    .notifier,
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
    final editableGame = ref
        .watch(addGameProvider(widget.initialValue, widget.initialPlayStatus));

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          widget.initialValue == null
              ? AppLocalizations.of(context)!.addGame
              : AppLocalizations.of(context)!.editGame,
        ),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                    vertical: 4.0,
                  ),
                  child: NameInputField(
                    value: editableGame.name,
                    onChanged: (value) {
                      ref
                          .read(
                            addGameProvider(
                              widget.initialValue,
                              widget.initialPlayStatus,
                            ).notifier,
                          )
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
                          .read(
                            addGameProvider(
                              widget.initialValue,
                              widget.initialPlayStatus,
                            ).notifier,
                          )
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
                      PriceVariant variant = selection == PlayStatus.onWishList
                          ? PriceVariant.observing
                          : editableGame.priceVariant;

                      if (variant == PriceVariant.observing &&
                          selection != PlayStatus.onWishList) {
                        variant = PriceVariant.bought;
                      }
                      ref
                          .read(
                            addGameProvider(
                              widget.initialValue,
                              widget.initialPlayStatus,
                            ).notifier,
                          )
                          .updateGame(
                            editableGame.copyWith(
                              status: selection,
                              priceVariant: variant,
                            ),
                          );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: PriceVariantDropdown(
                    enabled: editableGame.status != PlayStatus.onWishList,
                    value: editableGame.priceVariant,
                    onSelect: (selection) {
                      ref
                          .read(
                            addGameProvider(
                              widget.initialValue,
                              widget.initialPlayStatus,
                            ).notifier,
                          )
                          .updateGame(
                            editableGame.copyWith(priceVariant: selection),
                          );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: AnimatedSize(
                    curve: Curves.easeInOutBack,
                    duration: const Duration(milliseconds: 200),
                    child: Builder(
                      builder: (context) {
                        if (!editableGame.priceVariant.hasPrice) {
                          return const SizedBox(
                            height: 0,
                          );
                        }

                        return PriceInputField(
                          value: editableGame.price,
                          onChanged: (value) {
                            ref
                                .read(
                                  addGameProvider(
                                    widget.initialValue,
                                    widget.initialPlayStatus,
                                  ).notifier,
                                )
                                .updateGame(
                                  editableGame.copyWith(price: value),
                                );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: USKDropdown(
                    onChanged: (value) {
                      ref
                          .read(
                            addGameProvider(
                              widget.initialValue,
                              widget.initialPlayStatus,
                            ).notifier,
                          )
                          .updateGame(editableGame.copyWith(usk: value));
                    },
                    value: editableGame.usk,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                    vertical: 4.0,
                  ),
                  child: NotesInputField(
                    value: editableGame.notes,
                    onChanged: (value) {
                      ref
                          .read(
                            addGameProvider(
                              widget.initialValue,
                              widget.initialPlayStatus,
                            ).notifier,
                          )
                          .updateGame(
                            editableGame.copyWith(
                              notes: value.isEmpty ? null : value,
                            ),
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
                                .read(
                                  addGameProvider(
                                    widget.initialValue,
                                    widget.initialPlayStatus,
                                  ).notifier,
                                )
                                .updateGame(
                                  editableGame.copyWith(
                                    dlcs: [
                                      ...editableGame.dlcs,
                                      result.toDLC(),
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
                          .values,
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
