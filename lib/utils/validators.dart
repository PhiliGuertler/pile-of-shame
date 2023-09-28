import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class Validators {
  const Validators._();

  static String? Function(String? value) validateFieldIsRequired(
    BuildContext context,
  ) =>
      (String? value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.thisFieldIsRequired;
        }
        return null;
      };
}
