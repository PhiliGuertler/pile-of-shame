import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/screens/analytics_by_families_screen.dart';
import 'package:pile_of_shame/features/games/games_by_playstatus/screens/games_by_playstatus_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/parallax_image_card.dart';

int _countGamesForPlayStatus(List<Game> games, List<PlayStatus> statuses) {
  return games.fold<int>(
    0,
    (previousValue, element) =>
        (statuses.contains(element.status) ? 1 : 0) + previousValue,
  );
}

int _countGamesForPlatformFamily(
  List<Game> games,
  List<GamePlatformFamily> families,
) {
  return games.fold<int>(
    0,
    (previousValue, element) =>
        (families.contains(element.platform.family) ? 1 : 0) + previousValue,
  );
}

class LibraryScreen extends ConsumerWidget {
  final ScrollController scrollController;

  const LibraryScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final platformFamilies =
        ref.watch(gamePlatformFamiliesWithSavedGamesProvider);
    final games = ref.watch(gamesProvider);

    return games.when(
      data: (games) => platformFamilies.when(
        data: (families) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingX),
          child: ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  l10n.gameLibrary,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ParallaxImageCard(
                  key: const ValueKey("library_playing"),
                  imageAsset: ImageAssets.controllerUnknown,
                  title: PlayStatus.playing.toLocaleString(l10n),
                  subtitle: l10n.nGames(
                    _countGamesForPlayStatus(games, [PlayStatus.playing]),
                  ),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.playing,
                      PlayStatus.replaying,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ParallaxImageCard(
                  key: const ValueKey("library_pile_of_shame"),
                  imageAsset: ImageAssets.gamePile,
                  title: PlayStatus.onPileOfShame.toLocaleString(l10n),
                  subtitle: l10n.nGames(
                    _countGamesForPlayStatus(games, [PlayStatus.onPileOfShame]),
                  ),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.onPileOfShame,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ParallaxImageCard(
                  key: const ValueKey("library_on_wish_list"),
                  imageAsset: ImageAssets.list,
                  title: PlayStatus.onWishList.toLocaleString(l10n),
                  subtitle: l10n.nGames(
                    _countGamesForPlayStatus(games, [PlayStatus.onWishList]),
                  ),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.onWishList,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ParallaxImageCard(
                  key: const ValueKey("library_completed"),
                  imageAsset: ImageAssets.barChart,
                  title: PlayStatus.completed.toLocaleString(l10n),
                  subtitle: l10n.nGames(
                    _countGamesForPlayStatus(
                      games,
                      [PlayStatus.completed, PlayStatus.completed100Percent],
                    ),
                  ),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.completed,
                      PlayStatus.completed100Percent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ParallaxImageCard(
                  key: const ValueKey("library_cancelled"),
                  imageAsset: ImageAssets.deadGame,
                  title: PlayStatus.cancelled.toLocaleString(l10n),
                  subtitle: l10n.nGames(
                    _countGamesForPlayStatus(
                      games,
                      [PlayStatus.cancelled],
                    ),
                  ),
                  openBuilderOnTap: (context, openContainer) =>
                      GamesByPlaystatusScreen(
                    playStatuses: const [
                      PlayStatus.cancelled,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 64.0, bottom: 16.0),
                child: Text(
                  l10n.analytics,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ParallaxImageCard(
                  key: const ValueKey("library_analytics"),
                  imageAsset: ImageAssets.library,
                  title: AppLocalizations.of(context)!.gameLibrary,
                  subtitle: l10n.nGames(games.length),
                  openBuilderOnTap: (context, openContainer) =>
                      const AnalyticsByFamiliesScreen(),
                ),
              ),
              for (final family in families)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ParallaxImageCard(
                    imageAsset: family.image,
                    title: family.toLocale(AppLocalizations.of(context)!),
                    subtitle: l10n.nGames(
                      _countGamesForPlatformFamily(games, [family]),
                    ),
                    openBuilderOnTap: (context, openContainer) =>
                        AnalyticsByFamiliesScreen(family: family),
                  ),
                ),
              const SizedBox(
                height: 78.0,
              ),
            ],
          ),
        ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => ListView(),
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => ListView(),
    );
  }
}
