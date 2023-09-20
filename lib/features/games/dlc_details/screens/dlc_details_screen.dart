import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/screens/add_or_edit_dlc_screen.dart';
import 'package:pile_of_shame/features/games/dlc_details/widgets/sliver_dlc_details.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';

class DLCDetailsScreen extends ConsumerWidget {
  final Game game;
  final String dlcId;

  const DLCDetailsScreen({
    super.key,
    required this.game,
    required this.dlcId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dlc = ref.watch(dlcByGameAndIdProvider(game.id, dlcId));

    return AppScaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(gamesProvider.future),
          child: dlc.when(
            skipLoadingOnReload: true,
            loading: () => const CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverFancyImageAppBar(
                  borderRadius: -defaultBorderRadius * 2,
                  imagePath: "assets/misc/loading.webp",
                ),
                SliverDLCDetailsSkeleton(),
              ],
            ),
            error: (error, stackTrace) => CustomScrollView(
              slivers: [
                SliverFancyImageAppBar(
                  borderRadius: -defaultBorderRadius * 2,
                  imagePath: GamePlatform.unknown.controllerLogoPath,
                ),
                Text(error.toString()),
              ],
            ),
            data: (dlc) => CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverFancyImageAppBar(
                  borderRadius: -defaultBorderRadius * 2,
                  imagePath: game.platform.controllerLogoPath,
                  actions: [
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
                          final updatedGame = game.copyWith(dlcs: updatedDLCs);

                          final gamesList =
                              await ref.read(gamesProvider.future);
                          final update =
                              gamesList.updateGame(updatedGame.id, updatedGame);

                          ref
                              .read(gameStorageProvider)
                              .persistGamesList(update);
                        }
                      },
                    ),
                  ],
                  title: Text(dlc.name),
                ),
                SliverDLCDetails(
                  game: game,
                  dlc: dlc,
                ),
              ],
            ).animate().fadeIn(),
          ),
        ),
      ),
    );
  }
}
