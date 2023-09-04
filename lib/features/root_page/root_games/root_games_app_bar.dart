import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class RootGamesAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ScrollController scrollController;

  final preferredSizeAppBar = AppBar();

  RootGamesAppBar({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.games,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {},
        ),
        Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;
}
