import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/name_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/notes_input_field.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/platform_dropdown.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/price_input_field.dart';
import 'package:pile_of_shame/features/hardware/add_or_edit_hardware/models/editable_hardware.dart';
import 'package:pile_of_shame/features/hardware/add_or_edit_hardware/providers/edit_hardware_provider.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class AddOrEditHardwareScreen extends ConsumerStatefulWidget {
  final EditableHardware? initialValue;

  const AddOrEditHardwareScreen({super.key, this.initialValue});

  @override
  ConsumerState<AddOrEditHardwareScreen> createState() =>
      _AddOrEditHardwareScreenState();
}

class _AddOrEditHardwareScreenState
    extends ConsumerState<AddOrEditHardwareScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final editableHardware =
        ref.watch(addHardwareProvider(widget.initialValue));

    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(
        title: Text(l10n.hardware),
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
                    value: editableHardware.name,
                    onChanged: (value) {
                      ref
                          .read(
                            addHardwareProvider(
                              widget.initialValue,
                            ).notifier,
                          )
                          .updateHardware(
                            editableHardware.copyWith(name: value),
                          );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: PlatformDropdown(
                    value: editableHardware.platform,
                    onChanged: (value) {
                      ref
                          .read(
                            addHardwareProvider(
                              widget.initialValue,
                            ).notifier,
                          )
                          .updateHardware(
                            editableHardware.copyWith(platform: value),
                          );
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
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Center(
                            child: ImageContainer(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  ImageContainer.borderRadius,
                                ),
                                onTap: () {
                                  final newValue = !editableHardware.wasGifted;
                                  ref
                                      .read(
                                        addHardwareProvider(
                                          widget.initialValue,
                                        ).notifier,
                                      )
                                      .updateHardware(
                                        editableHardware.copyWith(
                                          wasGifted: newValue,
                                        ),
                                      );
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.cake_sharp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                      .animate(
                                        target:
                                            editableHardware.wasGifted ? 0 : 1,
                                      )
                                      .shake()
                                      .scale(
                                        begin: const Offset(1.0, 1.0),
                                        end: const Offset(1.2, 1.2),
                                        curve: Curves.easeInOutBack,
                                      )
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
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: PriceInputField(
                            enabled: !editableHardware.wasGifted,
                            value: editableHardware.price,
                            onChanged: (value) {
                              ref
                                  .read(
                                    addHardwareProvider(
                                      widget.initialValue,
                                    ).notifier,
                                  )
                                  .updateHardware(
                                    editableHardware.copyWith(price: value),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                    vertical: 4.0,
                  ),
                  child: NotesInputField(
                    value: editableHardware.notes,
                    onChanged: (value) {
                      ref
                          .read(
                            addHardwareProvider(
                              widget.initialValue,
                            ).notifier,
                          )
                          .updateHardware(
                            editableHardware.copyWith(
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
                      key: const ValueKey("save_game"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            editableHardware.isValid()) {
                          if (context.mounted) {
                            Navigator.of(context).pop(editableHardware);
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
