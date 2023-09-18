import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_game/providers/add_game_provider.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/utils/validators.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/input/number_input_field.dart';
import 'package:pile_of_shame/widgets/input/text_input_field.dart';

import '../widgets/play_status_dropdown.dart';

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
    final editableDLC = ref.watch(addDLCProvider(widget.initialValue));

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          widget.initialValue == null
              ? AppLocalizations.of(context)!.addDLC
              : AppLocalizations.of(context)!.editDLC,
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
                      horizontal: defaultPaddingX, vertical: 4.0),
                  child: TextInputField(
                    label: Text('${AppLocalizations.of(context)!.name}*'),
                    textInputAction: TextInputAction.next,
                    initialValue: editableDLC.name ?? '',
                    onChanged: (value) {
                      ref
                          .read(addDLCProvider(widget.initialValue).notifier)
                          .updateDLC(editableDLC.copyWith(name: value));
                    },
                    validator: Validators.validateFieldIsRequired(context),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: PlayStatusDropdown(
                    value: editableDLC.status,
                    onSelect: (selection) {
                      ref
                          .read(addDLCProvider(widget.initialValue).notifier)
                          .updateDLC(editableDLC.copyWith(status: selection));
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                  child: NumberInputField(
                    label: Text(AppLocalizations.of(context)!.price),
                    textInputAction: TextInputAction.next,
                    initialValue: editableDLC.price,
                    onChanged: (value) {
                      ref
                          .read(addDLCProvider(widget.initialValue).notifier)
                          .updateDLC(editableDLC.copyWith(price: value));
                    },
                    isCurrency: true,
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
