import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/utils/validators.dart';
import 'package:pile_of_shame/widgets/input/text_input_field.dart';

class NameInputField extends StatelessWidget {
  final void Function(String value) onChanged;
  final String? value;

  const NameInputField({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      label: Text('${AppLocalizations.of(context)!.name}*'),
      textInputAction: TextInputAction.next,
      initialValue: value ?? '',
      onChanged: onChanged,
      validator: Validators.validateFieldIsRequired(context),
    );
  }
}
