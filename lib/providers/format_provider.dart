import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'format_provider.g.dart';

@riverpod
NumberFormat currencyFormat(CurrencyFormatRef ref, BuildContext context) {
  return NumberFormat.currency(
    decimalDigits: 2,
    symbol: '€',
  );
}

@riverpod
NumberFormat numberFormat(NumberFormatRef ref, BuildContext context) {
  return NumberFormat.decimalPatternDigits(
    decimalDigits: 2,
  );
}

@riverpod
DateFormat dateFormat(DateFormatRef ref) {
  return DateFormat.yMMMMd();
}
