import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

NavigationDestination rootLibraryDestination(BuildContext context) {
  return NavigationDestination(
    key: const ValueKey('root_library'),
    icon: const Icon(Icons.library_books_outlined),
    selectedIcon: const Icon(Icons.library_books)
        .animate()
        .flipH(
          begin: 0.0,
          end: 1.0,
          curve: Curves.easeInOut,
          duration: 150.ms,
        )
        .then(delay: 50.ms)
        .flipV(
          begin: 0.0,
          end: 1.0,
          curve: Curves.easeInOut,
          duration: 150.ms,
        ),
    label: AppLocalizations.of(context)!.library,
  );
}
