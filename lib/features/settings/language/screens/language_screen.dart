import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/extensions/locale_extensions.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/theming/theme_provider.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/fade_in_image_asset.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const flagDimension = 32.0;

    final themeSettings = ref.watch(appThemeSettingsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: ListView(
        children: [
          ...AppLocalizations.supportedLocales.map(
            (locale) => RadioListTile(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: SizedBox(
                        width: flagDimension,
                        height: flagDimension,
                        child: FadeInImageAsset(asset: locale.countryAsset()),
                      ),
                    ),
                  ),
                  Text(locale.fullName()),
                ],
              ),
              onChanged: (value) {
                ref
                    .read(appThemeSettingsProvider.notifier)
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
                    width: flagDimension,
                    height: flagDimension,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Icon(
                      Icons.settings_suggest_rounded,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Text(AppLocalizations.of(context)!.systemLanguage),
              ],
            ),
            onChanged: (value) {
              ref.read(appThemeSettingsProvider.notifier).setLocale(null);
            },
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: themeSettings.asData?.value.locale,
            value: null,
          ),
        ],
      ),
    );
  }
}
