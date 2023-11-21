import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theming/src/providers/theme_provider.dart';

class BrightnessSelectionRadioGroup extends ConsumerWidget {
  final String lightLabel;
  final String darkLabel;
  final String systemLabel;

  const BrightnessSelectionRadioGroup({
    super.key,
    this.lightLabel = "Light",
    this.darkLabel = "Dark",
    this.systemLabel = "Specified by the system",
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider);

    return Column(
      children: [
        RadioListTile(
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.light_mode_rounded),
              ),
              Text(lightLabel),
            ],
          ),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeSettingsProvider.notifier).setThemeMode(value);
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
              Text(darkLabel),
            ],
          ),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeSettingsProvider.notifier).setThemeMode(value);
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
              Text(systemLabel),
            ],
          ),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeSettingsProvider.notifier).setThemeMode(value);
            }
          },
          controlAffinity: ListTileControlAffinity.trailing,
          groupValue: themeSettings.asData?.value.themeMode,
          value: ThemeMode.system,
        ),
      ],
    );
  }
}
