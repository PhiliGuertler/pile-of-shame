import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

NavigationDestination rootLibraryDestination(BuildContext context) {
  return NavigationDestination(
    key: const ValueKey('root_library'),
    icon: const Icon(Icons.library_books_outlined),
    selectedIcon: const Icon(Icons.library_books).animate().shake(),
    label: AppLocalizations.of(context)!.library,
  );
}
