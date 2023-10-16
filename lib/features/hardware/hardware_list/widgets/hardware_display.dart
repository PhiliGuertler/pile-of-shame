import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/hardware/hardware_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
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
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(12.0),
            ),
            child: ColoredBox(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.3),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(30.0),
                            topRight: Radius.circular(12.0),
                          ),
                          child: Image.asset(
                            platform.controllerLogoPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ).animate().moveX(
                            begin: constraints.maxWidth - 80,
                            end: 0,
                            curve: Curves.easeInOut,
                            duration: 300.ms,
                          ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPaddingX - 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                platform.localizedAbbreviation(l10n),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                platform.localizedName(l10n),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                      ),
                      IntrinsicWidth(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: asyncPriceSum.when(
                            skipLoadingOnReload: true,
                            data: (sum) => Text(
                              currencyFormatter.format(sum),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            error: (error, stackTrace) =>
                                Text(error.toString()),
                            loading: () => const Skeleton(),
                          ),
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                    ],
                  );
                },
              ),
            ),
          ),
          ...asyncHardware.when(
            skipLoadingOnReload: true,
            data: (hardware) => hardware
                .map(
                  (ware) => ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: ware == hardware.last
                            ? const Radius.circular(12.0)
                            : Radius.zero,
                        bottomRight: ware == hardware.last
                            ? const Radius.circular(12.0)
                            : Radius.zero,
                      ),
                    ),
                    title: Text(ware.name),
                    subtitle: ware.wasGifted
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.cake,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  l10n.gift,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            currencyFormatter.format(ware.price),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      debugPrint("Tapped");
                    },
                  ).animate().fadeIn(duration: 150.ms).slideY(
                        begin: -0.1,
                        end: 0,
                        duration: 150.ms,
                        curve: Curves.easeInOut,
                      ),
                )
                .toList(),
            error: (error, stackTrace) => [Text(error.toString())],
            loading: () =>
                [for (int i = 0; i < 3; ++i) const ListTileSkeleton()],
          ),
        ],
      ),
    );
  }
}
