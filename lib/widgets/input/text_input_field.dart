import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final Widget label;
  final String? initialValue;
  final String? helperText;
  final bool enabled;
  final bool autofocus;

  /// Defaults to TextInputAction.next
  final TextInputAction textInputAction;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;

  const TextInputField({
    super.key,
    required this.label,
    this.initialValue,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.helperText,
    this.enabled = true,
    this.validator,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: label,
        enabled: enabled,
        helperText: helperText,
      ),
      textInputAction: textInputAction,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      autofocus: autofocus,
    );
  }
}
