import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

enum PlayStatus {
  playing(isCompleted: false),
  replaying(isCompleted: true),
  endlessGame(isCompleted: true),
  completed(isCompleted: true),
  completed100Percent(isCompleted: true),
  cancelled(isCompleted: false),
  onPileOfShame(isCompleted: false),
  onWishList(isCompleted: false),
  ;

  final bool isCompleted;

  const PlayStatus({
    required this.isCompleted,
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

  Color toBackgroundColor(BuildContext context) {
    switch (this) {
      case PlayStatus.completed:
        return Colors.green.shade400;
      case PlayStatus.completed100Percent:
        return Colors.green;
      case PlayStatus.endlessGame:
        return Colors.yellow.shade400;
      case PlayStatus.replaying:
        return Colors.orange.shade400;
      case PlayStatus.playing:
        return Colors.orange.shade700;
      case PlayStatus.cancelled:
        return Colors.red.shade600;
      case PlayStatus.onPileOfShame:
        return Colors.teal.shade500;
      case PlayStatus.onWishList:
        return Colors.purple.shade700;
    }
  }

  Color toForegroundColor(BuildContext context) {
    switch (this) {
      case PlayStatus.completed:
        return Colors.black;
      case PlayStatus.completed100Percent:
        return Colors.black;
      case PlayStatus.endlessGame:
        return Colors.black;
      case PlayStatus.replaying:
        return Colors.black;
      case PlayStatus.playing:
        return Colors.black;
      case PlayStatus.cancelled:
        return Colors.white;
      case PlayStatus.onPileOfShame:
        return Colors.white;
      case PlayStatus.onWishList:
        return Colors.white;
    }
  }
}
