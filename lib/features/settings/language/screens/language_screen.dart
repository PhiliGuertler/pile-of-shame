import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/extensions/locale_extensions.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/fade_in_image_asset.dart';
import 'package:theming/theming.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: SingleChildScrollView(
        child: LanguageSelectionRadioGroup(
          supportedLocales: AppLocalizations.supportedLocales,
          localeToImage: (locale) =>
              FadeInImageAsset(asset: locale.countryAsset()),
          localeToName: (locale) => locale.fullName(),
          systemLanguageLabel: AppLocalizations.of(context)!.systemLanguage,
        ),
      ),
    );
  }
}
