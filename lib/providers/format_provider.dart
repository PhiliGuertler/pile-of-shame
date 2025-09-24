import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/models/app_currency.dart';
import 'package:pile_of_shame/providers/currency_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'format_provider.g.dart';

@riverpod
NumberFormat currencyFormat(Ref ref, Locale locale) {
  final currency = ref.watch(currencySettingsProvider);

  final currencySymbol = currency.when(
    data: (data) => data.currency,
    error: (error, stackTrace) => CurrencySymbols.coin,
    loading: () => CurrencySymbols.coin,
  );

  return NumberFormat.currency(
    decimalDigits: 2,
    symbol: currencySymbol.symbol,
    locale: locale.toLanguageTag(),
  );
}

@riverpod
NumberFormat percentFormat(Ref ref, Locale locale) {
  return NumberFormat.percentPattern(
    locale.toLanguageTag(),
  );
}

@riverpod
NumberFormat numberFormat(Ref ref, Locale locale) {
  return NumberFormat.decimalPatternDigits(
    decimalDigits: 2,
    locale: locale.toLanguageTag(),
  );
}

@riverpod
DateFormat dateFormat(Ref ref, Locale locale) {
  return DateFormat.yMd(locale.toLanguageTag());
}

@riverpod
DateFormat timeFormat(Ref ref, Locale locale) {
  return DateFormat.Hms(locale.toLanguageTag());
}
