import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/providers/format_provider.dart';

class DecimalInputFormatter extends TextInputFormatter {
  final String decimalSeparator;
  final String thousandsSeparator;

  const DecimalInputFormatter({
    required this.decimalSeparator,
    required this.thousandsSeparator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regex = RegExp('^\\d*\\$decimalSeparator?\\d{0,2}\$');
    final String newString = regex.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}

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
    super.key,
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
    final numberFormatter = ref.watch(numberFormatProvider(context));
    final decimalSeparator = numberFormatter.symbols.DECIMAL_SEP;
    final thousandsSeparator = numberFormatter.symbols.GROUP_SEP;

    final startValue = initialValue != null
        ? numberFormatter
            .format(initialValue)
            .replaceAll(RegExp("\\$thousandsSeparator"), "")
        : null;

    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
      decoration: InputDecoration(
        label: label,
        enabled: enabled,
        helperText: helperText,
        suffix: isCurrency ? const Text("€") : null,
      ),
      inputFormatters: [
        DecimalInputFormatter(
          decimalSeparator: decimalSeparator,
          thousandsSeparator: thousandsSeparator,
        ),
        FilteringTextInputFormatter.allow(RegExp("[\\d$decimalSeparator]")),
      ],
      textInputAction: textInputAction,
      initialValue: startValue,
      onChanged: (textValue) {
        if (onChanged != null) {
          final parsed = numberFormatter.parse(textValue);
          onChanged!(parsed.toDouble());
        }
      },
      validator: validator,
    );
  }
}
