import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final Widget label;
  final String? initialValue;
  final String? helperText;
  final bool enabled;
  final bool autofocus;
  final bool isMultiline;
  final bool hasClearButton;

  /// Defaults to TextInputAction.next
  final TextInputAction textInputAction;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;

  const TextInputField({
    super.key,
    required this.label,
    this.initialValue,
    this.textInputAction = TextInputAction.next,
    this.isMultiline = false,
    this.onChanged,
    this.helperText,
    this.enabled = true,
    this.validator,
    this.autofocus = false,
    this.hasClearButton = false,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        label: widget.label,
        enabled: widget.enabled,
        helperText: widget.helperText,
        suffixIcon: widget.hasClearButton
            ? IconButton(
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call("");
                },
                icon: const Icon(Icons.clear),
              )
            : null,
      ),
      keyboardType: widget.isMultiline ? TextInputType.multiline : null,
      minLines: widget.isMultiline ? 1 : null,
      maxLines: widget.isMultiline ? 5 : null,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autofocus: widget.autofocus,
    );
  }
}
