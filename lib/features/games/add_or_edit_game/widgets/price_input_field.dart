import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/widgets/input/number_input_field.dart';

class PriceInputField extends StatelessWidget {
  final double? value;
  final void Function(double value) onChanged;

  const PriceInputField({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return NumberInputField(
      label: Text(AppLocalizations.of(context)!.price),
      textInputAction: TextInputAction.next,
      initialValue: value,
      onChanged: onChanged,
      isCurrency: true,
    );
  }
}
