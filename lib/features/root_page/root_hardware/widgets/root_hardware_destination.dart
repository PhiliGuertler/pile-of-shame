import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

NavigationDestination rootHardwareDestination(BuildContext context) {
  return NavigationDestination(
    key: const ValueKey('root_hardware'),
    icon: const Icon(Icons.adf_scanner_outlined),
    selectedIcon: const Icon(Icons.adf_scanner)
        .animate()
        .scale(
          end: const Offset(1.5, 1.5),
          curve: Curves.easeInOutBack,
          duration: 200.ms,
        )
        .moveY(
          begin: 0,
          end: -10.0,
          duration: 200.ms,
          curve: Curves.easeInOutBack,
        )
        .then(duration: 200.ms)
        .moveY(
          begin: 0,
          end: 10.0,
          duration: 300.ms,
          curve: Curves.elasticOut,
        )
        .shake(duration: 300.ms, curve: Curves.easeInOutBack)
        .then(duration: 200.ms)
        .scale(
          end: const Offset(1.0 / 1.5, 1.0 / 1.5),
          curve: Curves.easeInOutBack,
        ),
    label: AppLocalizations.of(context)!.hardware,
  );
}
