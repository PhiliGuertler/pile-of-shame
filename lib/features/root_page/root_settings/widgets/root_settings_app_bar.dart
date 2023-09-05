import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class RootSettingsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final preferredSizeAppBar = AppBar();

  RootSettingsAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.settings),
    );
  }

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;
}
