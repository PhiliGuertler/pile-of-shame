import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';

class RootGamesAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ScrollController scrollController;

  final preferredSizeAppBar = AppBar();

  RootGamesAppBar({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: GestureDetector(
        child: Text(AppLocalizations.of(context)!.games),
        onTap: () {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        },
      ),
      actions: [
        IconButton(
            onPressed: () async {
              final pickedFile = await ref.read(fileUtilsProvider).pickFile();
              if (pickedFile != null) {
                final gameStorage = ref.read(gameStorageProvider);
                final games = await gameStorage.readGamesFromFile(pickedFile);
                await gameStorage.persistGamesList(games);
              }
            },
            icon: const Icon(Icons.file_open_rounded)),
      ],
    );
  }

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;
}
