import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/providers/edit_game_provider.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/name_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/notes_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/play_status_dropdown.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/price_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/price_variant_dropdown.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/models/price_variant.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

class AddDLCScreen extends ConsumerStatefulWidget {
  final EditableDLC? initialValue;

  const AddDLCScreen({super.key, this.initialValue});

  @override
  ConsumerState<AddDLCScreen> createState() => _AddDLCScreenState();
}

class _AddDLCScreenState extends ConsumerState<AddDLCScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final editableDLC = ref.watch(addDLCProvider(widget.initialValue));

    return AppScaffold(
      appBar: AppBar(
        title: Text(widget.initialValue == null ? l10n.addDLC : l10n.editDLC),
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
                    value: editableDLC.name,
                    onChanged: (value) {
                      ref
                          .read(addDLCProvider(widget.initialValue).notifier)
                          .updateDLC(editableDLC.copyWith(name: value));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                  ),
                  child: PlayStatusDropdown(
                    value: editableDLC.status,
                    onSelect: (selection) {
                      PriceVariant variant = selection == PlayStatus.onWishList
                          ? PriceVariant.observing
                          : editableDLC.priceVariant;

                      if (variant == PriceVariant.observing &&
                          selection != PlayStatus.onWishList) {
                        variant = PriceVariant.bought;
                      }
                      ref
                          .read(addDLCProvider(widget.initialValue).notifier)
                          .updateDLC(
                            editableDLC.copyWith(
                              status: selection,
                              priceVariant: variant,
                            ),
                          );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                  ),
                  child: PriceVariantDropdown(
                    enabled: editableDLC.status != PlayStatus.onWishList,
                    value: editableDLC.priceVariant,
                    onSelect: (selection) {
                      ref
                          .read(addDLCProvider(widget.initialValue).notifier)
                          .updateDLC(
                            editableDLC.copyWith(
                              priceVariant: selection,
                              price: selection.hasPrice ? null : 0.0,
                            ),
                          );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                  ),
                  child: AnimatedSize(
                    curve: Curves.easeInOutBack,
                    duration: const Duration(milliseconds: 200),
                    child: Builder(
                      builder: (context) {
                        if (!editableDLC.priceVariant.hasPrice) {
                          return const SizedBox(height: 0);
                        }
                        return PriceInputField(
                          value: editableDLC.price,
                          onChanged: (value) {
                            ref
                                .read(
                                  addDLCProvider(widget.initialValue).notifier,
                                )
                                .updateDLC(editableDLC.copyWith(price: value));
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                    vertical: 4.0,
                  ),
                  child: NotesInputField(
                    value: editableDLC.notes,
                    onChanged: (value) {
                      ref
                          .read(addDLCProvider(widget.initialValue).notifier)
                          .updateDLC(
                            editableDLC.copyWith(
                              notes: value.isEmpty ? null : value,
                            ),
                          );
                    },
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
                        if (_formKey.currentState!.validate() &&
                            editableDLC.isValid()) {
                          Navigator.of(context).pop(editableDLC);
                          return;
                        }
                      },
                      child: Text(l10n.save),
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
