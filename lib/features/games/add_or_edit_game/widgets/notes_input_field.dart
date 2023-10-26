import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/widgets/input/text_input_field.dart';

class NotesInputField extends StatelessWidget {
  final String? value;
  final void Function(String value) onChanged;

  const NotesInputField({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      key: const ValueKey("dlc_notes"),
      isMultiline: true,
      label: Text(AppLocalizations.of(context)!.notes),
      textInputAction: TextInputAction.newline,
      initialValue: value ?? '',
      onChanged: onChanged,
      hasClearButton: true,
    );
  }
}
