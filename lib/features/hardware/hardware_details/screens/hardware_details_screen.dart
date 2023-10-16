import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/game_details/widgets/sliver_game_details.dart';
import 'package:pile_of_shame/features/hardware/hardware_details/widgets/sliver_hardware_details.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/hardware/hardware_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';

class HardwareDetailsScreen extends ConsumerWidget {
  final String hardwareId;

  const HardwareDetailsScreen({super.key, required this.hardwareId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hardware = ref.watch(hardwareByIdProvider(hardwareId));

    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      body: SafeArea(
        top: false,
        child: hardware.when(
          data: (hardware) => CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverFancyImageAppBar(
                imagePath: hardware.platform.controllerLogoPath,
                title: Text(hardware.name),
              ),
              SliverHardwareDetails(hardware: hardware),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 32.0,
                      left: defaultPaddingX,
                      right: defaultPaddingX,
                      bottom: 16.0,
                    ),
                    child: TextButton.icon(
                      icon: const Icon(Icons.delete),
                      label: Text(l10n.deleteHardware),
                      onPressed: () async {
                        final bool? result = await showAdaptiveDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog.adaptive(
                            title: Text(
                              l10n.deleteHardware,
                            ),
                            content: Text(
                              l10n.thisActionCannotBeUndone,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  l10n.cancel,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  l10n.delete,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (result != null && result) {
                          final database =
                              await ref.read(databaseProvider.future);
                          final update = database.removeHardware(hardwareId);

                          await ref
                              .read(databaseStorageProvider)
                              .persistDatabase(update);

                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          loading: () => CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverFancyImageAppBar(
                imagePath: ImageAssets.loading.value,
              ),
              const SliverGameDetailsSkeleton(),
            ],
          ),
          error: (error, stackTrace) => CustomScrollView(
            slivers: [
              SliverFancyImageAppBar(
                imagePath: GamePlatform.unknown.controllerLogoPath,
              ),
              SliverToBoxAdapter(
                child: Text(error.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
