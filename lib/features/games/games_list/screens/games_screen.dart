import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/widgets/error_display.dart';

import '../widgets/game_list_tile.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Games"),
        actions: [
          IconButton(
              onPressed: () async {
                final pickedFile = await ref.read(fileUtilsProvider).pickFile();
                if (pickedFile != null) {
                  debugPrint(pickedFile.toString());
                }
              },
              icon: const Icon(Icons.file_open_rounded)),
        ],
      ),
      body: SafeArea(
        child: games.when(
          data: (games) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(gamesProvider.future),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: games
                    .map(
                      (game) => SliverToBoxAdapter(
                        child: GameListTile(game: game),
                      ),
                    )
                    .toList(),
              ),
            );
          },
          error: (error, stackTrace) => ErrorDisplay(
            error: error,
            stackTrace: stackTrace,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
