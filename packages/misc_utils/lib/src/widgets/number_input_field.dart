import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormattedNumberTextEditingController extends TextEditingController {
  final NumberFormat formatter;
  final double initialValue;
  final int numDecimals;

  double _value;
  String _displayText;

  double get doubleValue => double.parse(_value.toStringAsFixed(numDecimals));

  FormattedNumberTextEditingController({
    required this.formatter,
    this.initialValue = 0.0,
    this.numDecimals = 2,
  })  : _value = initialValue,
        _displayText = formatter.format(initialValue) {
    text = formatter.format(_value);
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
    addListener(_listener);
  }

  @override
  void dispose() {
    removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (_displayText == text) {
      selection = TextSelection.fromPosition(TextPosition(offset: text.length));
      return;
    }

    final bool shouldRemoveLastCharacter =
        text.length == _displayText.length - 1;

    // remove all non-digit characters from the string
    String textNumberString = text.replaceAll(RegExp(r'[^\d]'), "");
    if (shouldRemoveLastCharacter) {
      textNumberString =
          textNumberString.substring(0, textNumberString.length - 1);
    }
    // read text as int and divide it by 100
    final textValue = int.tryParse(textNumberString) ?? 0;
    _value = textValue * 0.01;
    // Setting the text triggers another listener call, so we have to store the
    // updated value before re-triggering that to avoid stack overflows.
    _displayText = formatter.format(_value);
    text = _displayText;
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class NumberInputField extends StatelessWidget {
  final Widget label;
  final double? initialValue;
  final String? helperText;
  final bool enabled;

  /// Defaults to TextInputAction.next
  final TextInputAction textInputAction;
  final void Function(double value)? onChanged;
  final String? Function(String? value)? validator;

  final NumberFormat numberFormatter;

  const NumberInputField({
    required this.label,
    required this.numberFormatter,
    this.initialValue,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.helperText,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return _InternalNumberInputField(
      label: label,
      enabled: enabled,
      initialValue: initialValue,
      textInputAction: textInputAction,
      onChanged: onChanged,
      helperText: helperText,
      validator: validator,
      numberFormatter: numberFormatter,
    );
  }
}

class _InternalNumberInputField extends StatefulWidget {
  final Widget label;
  final double? initialValue;
  final String? helperText;
  final bool enabled;

  /// Defaults to TextInputAction.next
  final TextInputAction textInputAction;
  final void Function(double value)? onChanged;
  final String? Function(String? value)? validator;
  final NumberFormat numberFormatter;

  const _InternalNumberInputField({
    required this.label,
    required this.numberFormatter,
    this.initialValue,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.helperText,
    this.enabled = true,
    this.validator,
  });

  @override
  State<_InternalNumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<_InternalNumberInputField> {
  late FormattedNumberTextEditingController _controller;

  void _listener() {
    widget.onChanged?.call(_controller.doubleValue);
  }

  @override
  void initState() {
    super.initState();
    _controller = FormattedNumberTextEditingController(
      formatter: widget.numberFormatter,
      initialValue: widget.initialValue ?? 0.0,
    );
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.end,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: widget.label,
        enabled: widget.enabled,
        helperText: widget.helperText,
        hintText: widget.numberFormatter.format(0),
      ),
      controller: _controller,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
    );
  }
}
