import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class RootHardwareAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final preferredSizeAppBar = AppBar();

  RootHardwareAppBar({super.key});

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.hardware),
    );
  }
}