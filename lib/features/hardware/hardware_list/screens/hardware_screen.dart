import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/hardware/hardware_list/widgets/hardware_display.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/providers/hardware/hardware_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/responsiveness/responsive_wrap.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_header.dart';

class HardwareScreen extends ConsumerWidget {
  final ScrollController scrollController;

  const HardwareScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final platforms = ref.watch(hardwarePlatformsProvider);
    final hasHardware = ref.watch(hasHardwareProvider);

    return SafeArea(
      child: hasHardware.when(
        skipLoadingOnReload: false,
        data: (hasHardware) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(hardwareProvider.future),
            child: Builder(
              builder: (context) {
                if (hasHardware) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPaddingX),
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
                            error: (error, stackTrace) =>
                                [Text(error.toString())],
                            loading: () => [],
                          ),
                        ),
                        const SizedBox(
                          height: 78.0,
                        ),
                      ],
                    ),
                  );
                } else {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverFancyImageHeader(
                        imagePath: ImageAssets.pc.value,
                        height: 300,
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPaddingX,
                            vertical: 8.0,
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            l10n.addThePillarsOfYourPileOfShameByAddingHardware,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          );
        },
        loading: () => CustomScrollView(
          slivers: [
            SliverFancyImageHeader(imagePath: ImageAssets.loading.value),
          ],
        ),
        error: (error, stackTrace) => CustomScrollView(
          slivers: [
            SliverFancyImageHeader(
              imagePath: ImageAssets.deadGame.value,
              height: 300,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPaddingX,
                  vertical: 8.0,
                ),
                child: Text(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
