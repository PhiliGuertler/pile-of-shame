import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class RootLibraryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final preferredSizeAppBar = AppBar();

  RootLibraryAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.library),
    );
  }

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;
}
