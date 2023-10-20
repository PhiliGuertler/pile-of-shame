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
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Builder(
          builder: (context) {
            return IconButton(
              key: const ValueKey("sort_hardware"),
              icon: const Icon(Icons.sort),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
    );
  }
}
