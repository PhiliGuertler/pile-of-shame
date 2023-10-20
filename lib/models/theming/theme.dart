import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

part 'theme.freezed.dart';
part 'theme.g.dart';

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

class ColorIntConv implements JsonConverter<Color, int> {
  const ColorIntConv();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}

@freezed
class AppTheme with _$AppTheme {
  factory AppTheme({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(null) String? locale,
    @Default(Color(0xFF3B0000)) @ColorIntConv() Color primaryColor,
    @Default(CurrencySymbols.euro) CurrencySymbols currency,
  }) = _AppTheme;
  const AppTheme._();

  ColorScheme computeColorScheme(bool isLightTheme) {
    final Color harmonizedColor = primaryColor.harmonizeWith(primaryColor);
    final ColorScheme result = ColorScheme.fromSeed(
      seedColor: harmonizedColor,
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
    );
    return result;
  }

  factory AppTheme.fromJson(Map<String, dynamic> json) =>
      _$AppThemeFromJson(json);
}
