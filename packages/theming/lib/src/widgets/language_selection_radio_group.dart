import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theming/src/providers/theme_provider.dart';

class LanguageSelectionRadioGroup extends ConsumerWidget {
  final List<Locale> supportedLocales;
  final double iconSize;
  final String systemLanguageLabel;

  final String Function(Locale locale) localeToName;
  final Widget Function(Locale locale) localeToImage;

  const LanguageSelectionRadioGroup({
    super.key,
    required this.supportedLocales,
    required this.localeToName,
    required this.localeToImage,
    this.iconSize = 32.0,
    this.systemLanguageLabel = "System language",
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider);

    return Column(
      children: [
        ...supportedLocales.map(
          (locale) => RadioListTile(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: localeToImage(locale),
                    ),
                  ),
                ),
                Text(localeToName(locale)),
              ],
            ),
            onChanged: (value) {
              ref
                  .read(themeSettingsProvider.notifier)
                  .setLocale(locale.toLanguageTag());
            },
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: themeSettings.asData?.value.locale,
            value: locale.toLanguageTag(),
          ),
        ),
        RadioListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Icon(
                    Icons.settings_suggest_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Text(systemLanguageLabel),
            ],
          ),
          onChanged: (value) {
            ref.read(themeSettingsProvider.notifier).setLocale(null);
          },
          controlAffinity: ListTileControlAffinity.trailing,
          groupValue: themeSettings.asData?.value.locale,
          value: null,
        ),
      ],
    );
  }
}
