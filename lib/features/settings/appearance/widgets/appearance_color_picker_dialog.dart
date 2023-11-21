import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:theming/theming.dart';

class AppearanceColorPickerDialog extends StatelessWidget {
  const AppearanceColorPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.chooseAColor),
      content: const SingleChildScrollView(
        child: AppearanceColorPicker(
          additionalColors: [
            Color(0xFF3B0000),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }
}
