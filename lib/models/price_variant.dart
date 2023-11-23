import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

enum PriceVariant {
  bought(
    iconData: Icons.shopping_cart,
    backgroundColor: Color.fromRGBO(67, 160, 71, 1),
    foregroundColor: Colors.black,
  ),
  borrowed(
    iconData: Icons.people,
    backgroundColor: Color.fromRGBO(251, 140, 0, 1),
    foregroundColor: Colors.black,
  ),
  gifted(
    iconData: Icons.cake,
    backgroundColor: Color.fromRGBO(0, 172, 193, 1),
    foregroundColor: Colors.black,
  ),
  observing(
    iconData: Icons.visibility,
    backgroundColor: Color.fromRGBO(142, 36, 170, 1),
    foregroundColor: Colors.black,
  ),
  ;

  final Color foregroundColor;
  final Color backgroundColor;
  final IconData iconData;

  const PriceVariant({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.iconData,
  });

  String toLocaleString(AppLocalizations l10n) {
    switch (this) {
      case PriceVariant.bought:
        return l10n.bought;
      case PriceVariant.gifted:
        return l10n.gifted;
      case PriceVariant.borrowed:
        return l10n.borrowed;
      case PriceVariant.observing:
        return l10n.observing;
    }
  }
}
