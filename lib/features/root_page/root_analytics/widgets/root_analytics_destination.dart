import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

NavigationDestination rootAnalyticsDestination(BuildContext context) {
  return NavigationDestination(
    key: const ValueKey('root_analytics'),
    icon: const Icon(Icons.bar_chart_outlined),
    selectedIcon: const Icon(Icons.bar_chart)
        .animate()
        .scale(
          end: const Offset(1.0, 0.5),
          curve: Curves.bounceOut,
          duration: 200.ms,
        )
        .then(duration: 70.ms)
        .shake(curve: Curves.easeInOutBack, duration: 150.ms)
        .then(duration: 70.ms)
        .scale(
          end: const Offset(1.0, 3.0),
          curve: Curves.bounceOut,
        )
        .then(duration: 70.ms)
        .scale(
          end: const Offset(1.0, 2.0 / 3.0),
          curve: Curves.bounceOut,
        ),
    label: AppLocalizations.of(context)!.analytics,
  );
}
