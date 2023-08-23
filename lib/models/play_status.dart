import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

enum PlayStatus {
  completed100Percent(isCompleted: true),
  completed(isCompleted: true),
  replaying(isCompleted: true),
  endlessGame(isCompleted: true),
  playing(isCompleted: false),
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
    final colorScheme = Theme.of(context).colorScheme;

    switch (this) {
      case PlayStatus.completed:
      case PlayStatus.endlessGame:
      case PlayStatus.completed100Percent:
        return Colors.green;
      case PlayStatus.replaying:
      case PlayStatus.playing:
        return colorScheme.primaryContainer;
      case PlayStatus.cancelled:
        return colorScheme.errorContainer;
      case PlayStatus.onPileOfShame:
        return colorScheme.secondaryContainer;
      case PlayStatus.onWishList:
        return colorScheme.tertiaryContainer;
    }
  }

  Color toForegroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (this) {
      case PlayStatus.completed:
      case PlayStatus.endlessGame:
      case PlayStatus.completed100Percent:
        return Colors.black;
      case PlayStatus.replaying:
      case PlayStatus.playing:
        return colorScheme.onPrimaryContainer;
      case PlayStatus.cancelled:
        return colorScheme.onErrorContainer;
      case PlayStatus.onPileOfShame:
        return colorScheme.onSecondaryContainer;
      case PlayStatus.onWishList:
        return colorScheme.onTertiaryContainer;
    }
  }
}
