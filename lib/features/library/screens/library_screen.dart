import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/screens/analytics_by_families_screen.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/screens/games_by_playstatus_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/parallax_image_card.dart';
import 'package:pile_of_shame/widgets/responsiveness/responsive_wrap.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final platformFamilies =
        ref.watch(gamePlatformFamiliesWithSavedGamesProvider);

    return platformFamilies.when(
      data: (families) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPaddingX),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text(
                l10n.gameLibrary,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            ResponsiveWrap(
              children: [
                ParallaxImageCard(
                  imagePath: ImageAssets.pc.value,
                  title: PlayStatus.playing.toLocaleString(l10n),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.playing,
                      PlayStatus.replaying,
                    ],
                  ),
                ),
                ParallaxImageCard(
                  imagePath: ImageAssets.gamePile.value,
                  title: PlayStatus.onPileOfShame.toLocaleString(l10n),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.onPileOfShame,
                    ],
                  ),
                ),
                ParallaxImageCard(
                  imagePath: ImageAssets.list.value,
                  title: PlayStatus.onWishList.toLocaleString(l10n),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.onWishList,
                    ],
                  ),
                ),
                ParallaxImageCard(
                  imagePath: ImageAssets.barChart.value,
                  title: PlayStatus.completed.toLocaleString(l10n),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.completed,
                      PlayStatus.completed100Percent,
                    ],
                  ),
                ),
                ParallaxImageCard(
                  imagePath: ImageAssets.deadGame.value,
                  title: PlayStatus.cancelled.toLocaleString(l10n),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.cancelled,
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 64.0, bottom: 16.0),
              child: Text(
                l10n.analytics,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            ResponsiveWrap(
              children: [
                ParallaxImageCard(
                  imagePath: ImageAssets.library.value,
                  title: AppLocalizations.of(context)!.gameLibrary,
                  openBuilderOnTap: (context, openContainer) =>
                      const AnalyticsByFamiliesScreen(),
                ),
                for (final family in families)
                  ParallaxImageCard(
                    imagePath: family.image.value,
                    title: family.toLocale(AppLocalizations.of(context)!),
                    openBuilderOnTap: (context, openContainer) =>
                        AnalyticsByFamiliesScreen(family: family),
                  ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
          ],
        ),
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => ListView(),
    );
  }
}
