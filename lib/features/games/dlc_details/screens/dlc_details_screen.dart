import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_game/screens/add_dlc_screen.dart';
import 'package:pile_of_shame/features/games/dlc_details/widgets/sliver_dlc_details.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';

class DLCDetailsScreen extends ConsumerWidget {
  final String gameId;
  final String dlcId;

  const DLCDetailsScreen({
    super.key,
    required this.gameId,
    required this.dlcId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameByIdProvider(gameId));
    final dlc = ref.watch(dlcByGameAndIdProvider(gameId, dlcId));

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
                  data: (game) => dlc.maybeWhen(
                    data: (dlc) => [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final result =
                              await Navigator.of(context).push<EditableDLC?>(
                            MaterialPageRoute(
                              builder: (context) => AddDLCScreen(
                                initialValue: EditableDLC.fromDLC(dlc),
                              ),
                            ),
                          );

                          if (result != null) {
                            final List<DLC> updatedDLCs = List.from(game.dlcs);
                            final dlcIndex = updatedDLCs
                                .indexWhere((element) => element.id == dlc.id);
                            updatedDLCs[dlcIndex] = result.toDLC();
                            final updatedGame =
                                game.copyWith(dlcs: updatedDLCs);

                            final gamesList =
                                await ref.read(gamesProvider.future);
                            final update = gamesList.updateGame(
                                updatedGame.id, updatedGame);

                            ref
                                .read(gameStorageProvider)
                                .persistGamesList(update);
                          }
                        },
                      ),
                    ],
                    orElse: () => [],
                  ),
                  orElse: () => [],
                ),
                title: dlc.when(
                  data: (dlc) => Text(dlc.name),
                  error: (error, stackTrace) => const Text('Error'),
                  loading: () => const Skeleton(),
                ),
              ),
              SliverDLCDetails(
                gameId: gameId,
                dlcId: dlcId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
