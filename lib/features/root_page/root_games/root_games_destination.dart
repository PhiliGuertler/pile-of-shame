import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

NavigationDestination rootGamesDestination(BuildContext context) {
  return NavigationDestination(
    key: const ValueKey('games'),
    icon: const Icon(Icons.gamepad_outlined),
    selectedIcon: const Icon(Icons.gamepad)
        .animate()
        .scale(
          end: const Offset(1.5, 1.5),
          curve: Curves.bounceOut,
          duration: 200.ms,
        )
        .then(duration: 70.ms)
        .moveX(begin: 0.0, end: 10.0)
        .then()
        .moveX(begin: 0.0, end: -10.0)
        .then()
        .moveX(begin: 0.0, end: 10.0)
        .then()
        .moveX(begin: 0.0, end: -10.0)
        .then()
        .moveY(begin: 0.0, end: -10.0)
        .then()
        .moveY(begin: 0.0, end: 10.0)
        .then(duration: 200.ms)
        .scale(
          end: const Offset(1.0 / 1.5, 1.0 / 1.5),
          curve: Curves.bounceOut,
        ),
    label: AppLocalizations.of(context)!.games,
  );
}
