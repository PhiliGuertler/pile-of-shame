import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';

class GameListTile extends ConsumerWidget {
  final Game game;

  const GameListTile({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final dateFormatter = ref.watch(dateFormatProvider);

    return ListTile(
      title: Text(game.name),
      leading: GamePlatformIcon(
        platform: game.platform,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(currencyFormatter.format(game.fullPrice())),
          Text(dateFormatter.format(game.lastModified)),
        ],
      ),
    );
  }
}
