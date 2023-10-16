import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/hardware/widgets/hardware_display.dart';
import 'package:pile_of_shame/providers/hardware/hardware_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/responsiveness/responsive_wrap.dart';

class HardwareScreen extends ConsumerWidget {
  final ScrollController scrollController;

  const HardwareScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platforms = ref.watch(hardwarePlatformsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPaddingX),
      child: ListView(
        controller: scrollController,
        children: [
          ResponsiveWrap(
            children: platforms.when(
              skipLoadingOnReload: true,
              data: (data) => data
                  .map(
                    (e) => HardwareDisplay(platform: e),
                  )
                  .toList(),
              error: (error, stackTrace) => [Text(error.toString())],
              loading: () => [],
            ),
          ),
          const SizedBox(
            height: 78.0,
          ),
        ],
      ),
    );
  }
}
