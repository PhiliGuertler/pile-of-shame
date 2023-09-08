import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/theming/theme_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

import '../widgets/appearance_color_picker_dialog.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(appThemeSettingsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appearance),
      ),
      body: ListView(
        children: [
          RadioListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.light_mode_rounded),
                ),
                Text(AppLocalizations.of(context)!.light),
              ],
            ),
            onChanged: (value) {
              if (value != null) {
                ref.read(appThemeSettingsProvider.notifier).setThemeMode(value);
              }
            },
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: themeSettings.asData?.value.themeMode,
            value: ThemeMode.light,
          ),
          RadioListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.dark_mode_rounded),
                ),
                Text(AppLocalizations.of(context)!.dark),
              ],
            ),
            onChanged: (value) {
              if (value != null) {
                ref.read(appThemeSettingsProvider.notifier).setThemeMode(value);
              }
            },
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: themeSettings.asData?.value.themeMode,
            value: ThemeMode.dark,
          ),
          RadioListTile(
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.settings_rounded),
                ),
                Text(AppLocalizations.of(context)!.systemDefined),
              ],
            ),
            onChanged: (value) {
              if (value != null) {
                ref.read(appThemeSettingsProvider.notifier).setThemeMode(value);
              }
            },
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: themeSettings.asData?.value.themeMode,
            value: ThemeMode.system,
          ),
          themeSettings.maybeWhen(
            data: (themeSettings) => Padding(
              padding: const EdgeInsets.only(
                left: defaultPaddingX,
                right: defaultPaddingX,
                top: 24.0,
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AppearanceColorPickerDialog();
                    },
                  );
                },
                icon: const Icon(Icons.palette),
                label: Text(AppLocalizations.of(context)!.changeAppColor),
              ),
            ),
            orElse: () => Container(),
          ),
        ],
      ),
    );
  }
}
