import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/screens/add_or_edit_game_screen.dart';
import 'package:pile_of_shame/features/games/game_details/widgets/sliver_game_details.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

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
                  key: const ValueKey('error-appbar'),
                  imagePath: GamePlatform.unknown.controller.value,
                ),
                SliverToBoxAdapter(
                  child: Text(error.toString()),
                ),
              ],
            ).animate().fadeIn(),
            loading: () => CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverFancyImageAppBar(
                  key: const ValueKey('loading-appbar'),
                  imagePath: ImageAssets.loading.value,
                ),
                const SliverGameDetailsSkeleton(),
              ],
            ).animate().fadeIn(duration: 1.seconds),
            data: (game) => CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverFancyImageAppBar(
                  key: const ValueKey('appbar'),
                  imagePath: game.platform.controller.value,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result =
                            await Navigator.of(context).push<EditableGame?>(
                          MaterialPageSlideRoute(
                            builder: (context) => AddGameScreen(
                              initialValue: EditableGame.fromGame(game),
                            ),
                          ),
                        );

                        if (result != null) {
                          final updatedGame = result.toGame();
                          final database =
                              await ref.read(databaseProvider.future);
                          final update =
                              database.updateGame(updatedGame.id, updatedGame);

                          await ref
                              .read(databaseStorageProvider)
                              .persistDatabase(update);
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
                                AppLocalizations.of(context)!.deleteGame,
                              ),
                              content: Text(
                                AppLocalizations.of(context)!
                                    .thisActionCannotBeUndone,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (result != null && result) {
                            final database =
                                await ref.read(databaseProvider.future);
                            final update = database.removeGame(game.id);

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
            ).animate().fadeIn(),
          ),
        ),
      ),
    );
  }
}
