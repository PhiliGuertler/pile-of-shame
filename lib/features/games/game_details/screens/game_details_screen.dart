import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_game/screens/add_game_screen.dart';
import 'package:pile_of_shame/features/games/game_details/widgets/sliver_game_details.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverFancyImageAppBar(
                borderRadius: -defaultBorderRadius * 2,
                imagePath: game.when(
                  data: (game) => game.platform.controllerLogoPath,
                  error: (error, stackTrace) =>
                      GamePlatform.unknown.controllerLogoPath,
                  loading: () => GamePlatform.unknown.controllerLogoPath,
                ),
                actions: game.maybeWhen(
                  data: (game) => [
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
                  orElse: () => [],
                ),
                title: game.when(
                  data: (game) => Text(game.name),
                  error: (error, stackTrace) => const Text('Error'),
                  loading: () => const Skeleton(),
                ),
              ),
              SliverGameDetails(
                gameId: widget.gameId,
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPaddingX, vertical: defaultPaddingX),
                    child: game.maybeWhen(
                      data: (game) => TextButton.icon(
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
                      orElse: () => const SizedBox(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
