import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/settings/appearance/widgets/appearance_color_picker_dialog.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:theming/theming.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeSettings = ref.watch(themeSettingsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appearance),
      ),
      body: ListView(
        children: [
          BrightnessSelectionRadioGroup(
            darkLabel: l10n.dark,
            lightLabel: l10n.light,
            systemLabel: l10n.systemDefined,
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
