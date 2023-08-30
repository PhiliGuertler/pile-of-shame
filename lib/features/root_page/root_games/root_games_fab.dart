import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_game/screens/add_game_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/widgets/collapsing_floating_action_button.dart';

class RootGamesFab extends ConsumerWidget {
  final bool isExtended;

  const RootGamesFab({super.key, required this.isExtended});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CollapsingFloatingActionButton(
      key: const ValueKey('add'),
      icon: const Icon(Icons.add_rounded),
      label: Text(AppLocalizations.of(context)!.addGame),
      isExtended: isExtended,
      onPressed: () async {
        final result = await Navigator.of(context).push<EditableGame?>(
          MaterialPageRoute(
            builder: (context) => const AddGameScreen(),
          ),
        );

        if (result != null) {
          final games = await ref.read(gamesProvider.future);
          games.addGame(result.toGame());

          final gameStorage = ref.read(gameStorageProvider);
          await gameStorage.persistGamesList(games);
        }
      },
    );
  }
}
