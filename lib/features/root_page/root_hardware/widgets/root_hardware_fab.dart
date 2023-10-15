import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/widgets/collapsing_floating_action_button.dart';

class RootHardwareFab extends ConsumerWidget {
  final bool isExtended;

  const RootHardwareFab({
    super.key,
    required this.isExtended,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CollapsingFloatingActionButton(
      key: const ValueKey('add_hardware'),
      icon: const Icon(Icons.add_rounded),
      label: Text(AppLocalizations.of(context)!.addHardware),
      isExtended: isExtended,
      onPressed: () async {
        // TODO: Add hardware
        debugPrint("Add hardware");
        // final result = await Navigator.of(context).push<EditableGame?>(
        //   MaterialPageSlideRoute(
        //     builder: (context) =>
        //         AddGameScreen(initialPlayStatus: initialPlayStatus),
        //   ),
        // );

        // if (result != null) {
        //   final games = GamesList(games: await ref.read(gamesProvider.future));
        //   final update = games.addGame(result.toGame());

        //   final gameStorage = ref.read(gameStorageProvider);
        //   await gameStorage.persistGamesList(update);
        // }
      },
    );
  }
}
