import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/theming/theme_provider.dart';

class AppearanceColorPickerDialog extends ConsumerWidget {
  const AppearanceColorPickerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(appThemeSettingsProvider);

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.chooseAColor),
      content: SingleChildScrollView(
        child: BlockPicker(
          availableColors: const [
            Color(0xFF3B0000),
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.lime,
            Colors.lightGreen,
            Colors.green,
            Colors.teal,
            Colors.cyan,
            Colors.lightBlue,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
            Colors.pink,
            Colors.brown,
          ],
          pickerColor: themeSettings.maybeWhen(
            data: (themeSettings) => themeSettings.primaryColor,
            orElse: () => Colors.orange,
          ),
          onColorChanged: (value) {
            ref.read(appThemeSettingsProvider.notifier).setPrimaryColor(value);
          },
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
