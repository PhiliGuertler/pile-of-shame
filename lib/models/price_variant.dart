import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

enum PriceVariant {
  bought(
    iconData: Icons.shopping_cart,
    backgroundColor: Color.fromRGBO(148, 228, 152, 1),
    foregroundColor: Colors.black,
  ),
  borrowed(
    iconData: Icons.people,
    backgroundColor: Color.fromRGBO(223, 184, 136, 1),
    foregroundColor: Colors.black,
  ),
  gifted(
    iconData: Icons.cake,
    backgroundColor: Color.fromRGBO(142, 231, 243, 1),
    foregroundColor: Colors.black,
  ),
  observing(
    iconData: Icons.visibility,
    backgroundColor: Color.fromRGBO(222, 166, 238, 1),
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
