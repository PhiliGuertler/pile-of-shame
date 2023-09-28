import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/widgets/input/number_input_field.dart';

class PriceInputField extends StatelessWidget {
  final double? value;
  final void Function(double value) onChanged;
  final bool enabled;

  const PriceInputField({
    super.key,
    this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return NumberInputField(
      label: Text(AppLocalizations.of(context)!.price),
      initialValue: value,
      onChanged: onChanged,
      isCurrency: true,
      enabled: enabled,
    );
  }
}
