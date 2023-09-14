import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

enum PlayStatus {
  playing(
    isCompleted: false,
    backgroundColor: Color.fromRGBO(245, 124, 0, 1),
    foregroundColor: Colors.black,
    icon: Icons.sports_esports,
  ),
  replaying(
    isCompleted: true,
    backgroundColor: Color.fromRGBO(255, 167, 38, 1),
    foregroundColor: Colors.black,
    icon: Icons.sports_esports,
  ),
  endlessGame(
    isCompleted: true,
    backgroundColor: Color.fromRGBO(255, 238, 88, 1),
    foregroundColor: Colors.black,
    icon: Icons.all_inclusive,
  ),
  completed(
    isCompleted: true,
    backgroundColor: Color.fromRGBO(102, 187, 106, 1),
    foregroundColor: Colors.black,
    icon: Icons.done,
  ),
  completed100Percent(
    isCompleted: true,
    backgroundColor: Colors.green,
    foregroundColor: Colors.black,
    icon: Icons.done_all,
  ),
  cancelled(
    isCompleted: false,
    backgroundColor: Color.fromRGBO(229, 57, 53, 1),
    foregroundColor: Colors.white,
    icon: Icons.close,
  ),
  onPileOfShame(
    isCompleted: false,
    backgroundColor: Color.fromRGBO(0, 150, 136, 1),
    foregroundColor: Colors.white,
    icon: Icons.filter_none,
  ),
  onWishList(
    isCompleted: false,
    backgroundColor: Color.fromRGBO(123, 31, 162, 1),
    foregroundColor: Colors.white,
    icon: Icons.receipt_long,
  ),
  ;

  final bool isCompleted;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  const PlayStatus({
    required this.isCompleted,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  String toLocaleString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case PlayStatus.completed:
        return localizations.completed;
      case PlayStatus.completed100Percent:
        return localizations.completed100Percent;
      case PlayStatus.replaying:
        return localizations.replaying;
      case PlayStatus.endlessGame:
        return localizations.endlessGame;
      case PlayStatus.playing:
        return localizations.playing;
      case PlayStatus.cancelled:
        return localizations.cancelled;
      case PlayStatus.onPileOfShame:
        return localizations.onPileOfShame;
      case PlayStatus.onWishList:
        return localizations.onWishList;
    }
  }
}
