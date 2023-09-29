import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

NavigationDestination rootPlatformFamiliesDestination(BuildContext context) {
  return NavigationDestination(
    key: const ValueKey('root_platform_families'),
    icon: const Icon(Icons.family_restroom),
    selectedIcon: const Icon(Icons.family_restroom).animate().shake(),
    label: AppLocalizations.of(context)!.platform,
  );
}
