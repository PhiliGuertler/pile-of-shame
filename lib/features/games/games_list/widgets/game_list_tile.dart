import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/game_details/screens/game_details_screen.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';

class GameListTile extends ConsumerWidget {
  final Game game;

  const GameListTile({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final dateFormatter = ref.watch(dateFormatProvider(context));

    return DefaultTextStyle.merge(
      style: TextStyle(color: game.status.foregroundColor),
      child: ListTile(
        tileColor: game.status.backgroundColor,
        title: Text(game.name),
        subtitle: PlayStatusDisplay(playStatus: game.status),
        leading: GamePlatformIcon(
          platform: game.platform,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currencyFormatter.format(game.fullPrice())),
            Text(dateFormatter.format(game.lastModified)),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameDetailsScreen(
                gameId: game.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
