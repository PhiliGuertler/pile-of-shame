import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theming/theming.dart';

part 'l10n_provider.g.dart';

@riverpod
AppLocalizations l10n(L10nRef ref) {
  final appSettings = ref.watch(themeSettingsProvider);

  final platformLocale = Platform.localeName.split("_")[0];
  final String systemLocale =
      AppLocalizations.delegate.isSupported(Locale(platformLocale))
          ? platformLocale
          : "en";

  return lookupAppLocalizations(
    appSettings.maybeWhen(
      data: (data) => Locale(data.locale ?? systemLocale),
      orElse: () => Locale(systemLocale),
    ),
  );
}
