import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/screens/add_or_edit_game_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/transitions/material_page_slide_route.dart';
import 'package:pile_of_shame/widgets/collapsing_floating_action_button.dart';

class RootGamesFab extends ConsumerWidget {
  final bool isExtended;
  final PlayStatus? initialPlayStatus;

  const RootGamesFab({
    super.key,
    required this.isExtended,
    this.initialPlayStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CollapsingFloatingActionButton(
      key: const ValueKey('add_game'),
      icon: const Icon(Icons.add_rounded),
      label: Text(AppLocalizations.of(context)!.addGame),
      isExtended: isExtended,
      onPressed: () async {
        final result = await Navigator.of(context).push<EditableGame?>(
          MaterialPageSlideRoute(
            builder: (context) =>
                AddGameScreen(initialPlayStatus: initialPlayStatus),
          ),
        );

        if (result != null) {
          final database = await ref.read(databaseProvider.future);
          final update = database.addGame(result.toGame());

          await ref.read(databaseStorageProvider).persistDatabase(update);
        }
      },
    );
  }
}
