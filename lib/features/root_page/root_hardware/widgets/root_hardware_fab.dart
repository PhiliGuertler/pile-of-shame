import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/widgets/collapsing_floating_action_button.dart';
import 'package:uuid/uuid.dart';

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
        debugPrint("Open Add Hardware Screen here!");

        final hardware = VideoGameHardware(
          id: const Uuid().v4(),
          price: Random().nextDouble() * 50,
          name: "Hardware",
          lastModified: DateTime.now(),
          createdAt: DateTime.now(),
        );

        final database = await ref.read(databaseProvider.future);
        final update = database.addHardware(
          hardware,
          GamePlatform.values[Random().nextInt(GamePlatform.values.length)],
        );

        await ref.read(databaseStorageProvider).persistDatabase(update);
      },
    );
  }
}
