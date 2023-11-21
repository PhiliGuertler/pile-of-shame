import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/hardware/hardware_list/widgets/hardware_entry.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/hardware/hardware_provider.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/slide_expandable.dart';

class HardwareDisplay extends ConsumerStatefulWidget {
  final GamePlatform platform;

  const HardwareDisplay({
    super.key,
    required this.platform,
  });

  @override
  ConsumerState<HardwareDisplay> createState() => _HardwareDisplayState();
}

class _HardwareDisplayState extends ConsumerState<HardwareDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isAnimationForward = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: 400.ms);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    final AsyncValue<List<VideoGameHardware>> asyncHardware =
        ref.watch(sortedHardwareByPlatformProvider(widget.platform));
    final AsyncValue<double?> asyncPriceSum =
        ref.watch(hardwareTotalPriceByPlatformProvider(widget.platform));

    return SlideExpandable(
      imageAsset: widget.platform.controller,
      title: Text(
        widget.platform.localizedAbbreviation(l10n),
      ),
      subtitle: Text(
        widget.platform.localizedName(l10n),
      ),
      trailing: asyncPriceSum.when(
        skipLoadingOnReload: true,
        data: (sum) => sum != null
            ? Text(
                currencyFormatter.format(sum),
              )
            : Icon(
                Icons.cake,
                color: Theme.of(context).colorScheme.primary,
              ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Skeleton(),
      ),
      children: asyncHardware.when(
        skipLoadingOnReload: true,
        data: (hardware) {
          return hardware
              .map(
                (ware) => HardwareEntry(
                  hardware: ware,
                  isLastElement: ware == hardware.last,
                ),
              )
              .toList();
        },
        error: (error, stackTrace) => [Text(error.toString())],
        loading: () => [for (int i = 0; i < 3; ++i) const ListTileSkeleton()],
      ),
    );
  }
}
