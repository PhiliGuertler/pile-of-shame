import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/screens/add_or_edit_game_screen.dart';
import 'package:pile_of_shame/features/games/game_details/widgets/sliver_game_details.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';

class GameDetailsScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GameDetailsScreen({super.key, required this.gameId});

  @override
  ConsumerState<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends ConsumerState<GameDetailsScreen> {
  bool shouldShowPriceSum = true;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameByIdProvider(widget.gameId));

    return AppScaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(gamesProvider.future),
          child: game.when(
            skipLoadingOnReload: true,
            error: (error, stackTrace) => CustomScrollView(
              slivers: [
                SliverFancyImageAppBar(
                  borderRadius: -defaultBorderRadius * 2,
                  key: const ValueKey('error-appbar'),
                  imagePath: GamePlatform.unknown.controllerLogoPath,
                ),
                SliverToBoxAdapter(
                  child: Text(error.toString()),
                )
              ],
            ).animate().fadeIn(),
            loading: () => const CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverFancyImageAppBar(
                  key: ValueKey('loading-appbar'),
                  borderRadius: -defaultBorderRadius * 2,
                  imagePath: 'assets/misc/loading.webp',
                ),
                SliverGameDetailsSkeleton(),
              ],
            ).animate().fadeIn(duration: 1.seconds),
            data: (game) => CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverFancyImageAppBar(
                  key: const ValueKey('appbar'),
                  borderRadius: -defaultBorderRadius * 2,
                  imagePath: game.platform.controllerLogoPath,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result =
                            await Navigator.of(context).push<EditableGame?>(
                          MaterialPageRoute(
                            builder: (context) => AddGameScreen(
                              initialValue: EditableGame.fromGame(game),
                            ),
                          ),
                        );

                        if (result != null) {
                          final updatedGame = result.toGame();
                          final gamesList =
                              await ref.read(gamesProvider.future);
                          final update =
                              gamesList.updateGame(updatedGame.id, updatedGame);

                          await ref
                              .read(gameStorageProvider)
                              .persistGamesList(update);
                        }
                      },
                    ),
                  ],
                  title: Text(game.name),
                ),
                SliverGameDetails(
                  game: game,
                ),
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
                        label: Text(AppLocalizations.of(context)!.deleteGame),
                        onPressed: () async {
                          final bool? result = await showAdaptiveDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog.adaptive(
                              title: Text(
                                  AppLocalizations.of(context)!.deleteGame),
                              content: Text(AppLocalizations.of(context)!
                                  .thisActionCannotBeUndone),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (result != null && result) {
                            final games = await ref.read(gamesProvider.future);
                            final update = games.removeGame(game.id);

                            final gameStorage = ref.read(gameStorageProvider);
                            await gameStorage.persistGamesList(update);

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
            ).animate().fadeIn(),
          ),
        ),
      ),
    );
  }
}
