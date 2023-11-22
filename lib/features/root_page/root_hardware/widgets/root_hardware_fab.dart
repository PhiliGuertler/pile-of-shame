import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/hardware/add_or_edit_hardware/models/editable_hardware.dart';
import 'package:pile_of_shame/features/hardware/add_or_edit_hardware/screens/add_or_edit_hardware_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';

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
        final result = await Navigator.of(context).push<EditableHardware?>(
          MaterialPageSlideRoute(
            builder: (context) => const AddOrEditHardwareScreen(),
          ),
        );

        if (result != null) {
          final database = await ref.read(databaseProvider.future);
          final update = database.addHardware(
            result.toHardware(),
          );

          await ref.read(databaseStorageProvider).persistDatabase(update);
        }
      },
    );
  }
}
