import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/format_provider.dart';

class PriceInputField extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    return NumberInputField(
      label: Text(AppLocalizations.of(context)!.price),
      initialValue: value,
      onChanged: onChanged,
      enabled: enabled,
      numberFormatter: numberFormatter,
    );
  }
}
