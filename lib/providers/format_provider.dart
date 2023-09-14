import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'format_provider.g.dart';

@riverpod
NumberFormat currencyFormat(CurrencyFormatRef ref, BuildContext context) {
  return NumberFormat.currency(
    decimalDigits: 2,
    symbol: '€',
    locale: Localizations.localeOf(context).toLanguageTag(),
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
