import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/game_provider.dart';

class RootGamesAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final preferredSizeAppBar = AppBar();

  RootGamesAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.games),
      actions: [
        IconButton(
            onPressed: () async {
              final pickedFile = await ref.read(fileUtilsProvider).pickFile();
              if (pickedFile != null) {
                await ref
                    .read(gamesProvider.notifier)
                    .importGamesFromFile(pickedFile);
              }
            },
            icon: const Icon(Icons.file_open_rounded)),
      ],
    );
  }

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;
}
