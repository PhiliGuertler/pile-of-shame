import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_game/providers/add_game_provider.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/utils/validators.dart';
import 'package:pile_of_shame/widgets/input/number_input_field.dart';
import 'package:pile_of_shame/widgets/input/text_input_field.dart';

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
                  child: DropdownButtonFormField<PlayStatus>(
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.status),
                      suffixIcon: const Icon(Icons.expand_more),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(addDLCProvider(widget.initialValue).notifier)
                            .updateDLC(editableDLC.copyWith(status: value));
                      }
                    },
                    // Display the text of selected items only, as the prefix-icon takes care of the logo
                    selectedItemBuilder: (context) => PlayStatus.values
                        .map((status) => Text(status.toLocaleString(context)))
                        .toList(),
                    // Don't display the default icon, instead display nothing
                    icon: const SizedBox(),
                    value: editableDLC.status,
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
