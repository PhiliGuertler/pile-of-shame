import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/widgets/game_list_tile.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/widgets/error_display.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Games")),
      body: SafeArea(
        child: games.when(
          data: (games) {
            return CustomScrollView(
              slivers: games
                  .map(
                    (game) => SliverToBoxAdapter(
                      child: GameListTile(game: game),
                    ),
                  )
                  .toList(),
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
