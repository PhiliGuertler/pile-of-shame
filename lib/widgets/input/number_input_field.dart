import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/providers/format_provider.dart';

class NumberInputField extends ConsumerWidget {
  final Widget label;
  final double? initialValue;
  final String? helperText;
  final bool enabled;
  final bool isCurrency;

  /// Defaults to TextInputAction.next
  final TextInputAction textInputAction;
  final void Function(double value)? onChanged;
  final String? Function(String? value)? validator;

  const NumberInputField({
    required this.label,
    this.initialValue,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.helperText,
    this.enabled = true,
    this.isCurrency = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormatter = ref.watch(currencyFormatProvider(context));
    return _InternalNumberInputField(
      label: label,
      enabled: enabled,
      initialValue: initialValue,
      textInputAction: textInputAction,
      onChanged: onChanged,
      helperText: helperText,
      isCurrency: isCurrency,
      validator: validator,
      numberFormatter: numberFormatter,
    );
  }
}

class _InternalNumberInputField extends ConsumerStatefulWidget {
  final Widget label;
  final double? initialValue;
  final String? helperText;
  final bool enabled;
  final bool isCurrency;

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
    this.isCurrency = false,
    this.validator,
  });

  @override
  ConsumerState<_InternalNumberInputField> createState() =>
      _NumberInputFieldState();
}

class _NumberInputFieldState extends ConsumerState<_InternalNumberInputField> {
  late CurrencyTextFieldController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CurrencyTextFieldController(
      initDoubleValue: widget.initialValue ?? 0.0,
      enableNegative: false,
      currencyOnLeft: false,
      decimalSymbol: widget.numberFormatter.symbols.DECIMAL_SEP,
      thousandSymbol: widget.numberFormatter.symbols.GROUP_SEP,
      currencySymbol: widget.numberFormatter.currencySymbol,
    );
    _controller.addListener(() {
      String fieldContent = _controller.value.text;
      fieldContent =
          fieldContent.replaceAll(widget.numberFormatter.currencySymbol, "");
      if (fieldContent.isEmpty) {
        widget.onChanged?.call(0.0);
      } else {
        final value = widget.numberFormatter.parse(fieldContent.trim());
        widget.onChanged?.call(value.toDouble());
      }
    });
  }

  @override
  void dispose() {
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
