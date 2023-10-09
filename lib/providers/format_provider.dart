import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/models/theming/theme.dart';
import 'package:pile_of_shame/providers/theming/theme_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'format_provider.g.dart';

@riverpod
NumberFormat currencyFormat(CurrencyFormatRef ref, BuildContext context) {
  final appTheme = ref.watch(appThemeSettingsProvider);

  final currencySymbol = appTheme.when(
    data: (data) => data.currency,
    error: (error, stackTrace) => CurrencySymbols.coin,
    loading: () => CurrencySymbols.coin,
  );

  return NumberFormat.currency(
    decimalDigits: 2,
    symbol: currencySymbol.symbol,
    locale: Localizations.localeOf(context).toLanguageTag(),
  );
}

@riverpod
NumberFormat percentFormat(PercentFormatRef ref, BuildContext context) {
  return NumberFormat.percentPattern(
    Localizations.localeOf(context).toLanguageTag(),
  );
}

@riverpod
NumberFormat numberFormat(NumberFormatRef ref, BuildContext context) {
  return NumberFormat.decimalPatternDigits(
    decimalDigits: 2,
    locale: Localizations.localeOf(context).toLanguageTag(),
  );
}

@riverpod
DateFormat dateFormat(DateFormatRef ref, BuildContext context) {
  return DateFormat.yMd(Localizations.localeOf(context).toLanguageTag());
}

@riverpod
DateFormat timeFormat(TimeFormatRef ref, BuildContext context) {
  return DateFormat.Hms(Localizations.localeOf(context).toLanguageTag());
}
