import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

part 'app_currency.freezed.dart';
part 'app_currency.g.dart';

enum CurrencySymbols {
  euro(symbol: '€'),
  dollar(symbol: '\$'),
  pound(symbol: '£'),
  yen(symbol: '¥'),
  won(symbol: '₩'),
  coin(symbol: '🪙'),
  ;

  final String symbol;

  String localeName(AppLocalizations l10n) {
    switch (this) {
      case CurrencySymbols.euro:
        return l10n.currencyEuro;
      case CurrencySymbols.dollar:
        return l10n.currencyDollar;
      case CurrencySymbols.pound:
        return l10n.currencyPound;
      case CurrencySymbols.yen:
        return l10n.currencyYen;
      case CurrencySymbols.won:
        return l10n.currencyWon;
      case CurrencySymbols.coin:
        return l10n.currencyCoin;
    }
  }

  const CurrencySymbols({required this.symbol});
}

@freezed
abstract class AppCurrency with _$AppCurrency {
  const factory AppCurrency({
    @Default(CurrencySymbols.euro) CurrencySymbols currency,
  }) = _AppCurrency;
  const AppCurrency._();

  factory AppCurrency.fromJson(Map<String, dynamic> json) =>
      _$AppCurrencyFromJson(json);
}
