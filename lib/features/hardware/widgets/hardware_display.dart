import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/hardware/hardware_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/custom_toolbar.dart';
import 'package:pile_of_shame/widgets/parallax_image_card.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';

class HardwareDisplay extends ConsumerWidget {
  final GamePlatform platform;

  const HardwareDisplay({super.key, required this.platform});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final AsyncValue<List<VideoGameHardware>> asyncHardware =
        ref.watch(hardwareByPlatformProvider(platform));
    final AsyncValue<double> asyncPriceSum =
        ref.watch(hardwareTotalPriceByPlatformProvider(platform));

    return Card(
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ParallaxImage(
                  imagePath: platform.controllerLogoPath,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: minimumToolbarHeight,
                    child: CustomToolbar(
                      title: Text(
                        platform.localizedName(l10n),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            // TODO: Implement editing
                            debugPrint("TODO: Implement me");
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...asyncHardware.when(
            skipLoadingOnReload: true,
            data: (hardware) => hardware
                .map(
                  (ware) => ListTile(
                    title: Text(ware.name),
                    trailing: Text(currencyFormatter.format(ware.price)),
                  ),
                )
                .toList(),
            error: (error, stackTrace) => [Text(error.toString())],
            loading: () =>
                [for (int i = 0; i < 3; ++i) const ListTileSkeleton()],
          ),
          const Divider(),
          asyncPriceSum.when(
            skipLoadingOnReload: true,
            data: (sum) => ListTile(
              title: Text(l10n.fullPrice),
              trailing: Text(
                currencyFormatter.format(sum),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Skeleton(),
          ),
        ],
      ),
    );
  }
}
