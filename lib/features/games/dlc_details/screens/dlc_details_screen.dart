import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/dlc_details/widgets/sliver_dlc_details.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
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

    return Scaffold(
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
                  data: (game) => game.platform.controllerLogoPath(context),
                  error: (error, stackTrace) =>
                      GamePlatform.unknown.controllerLogoPath(context),
                  loading: () =>
                      GamePlatform.unknown.controllerLogoPath(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      debugPrint('TODO: Implement editing');
                    },
                  )
                ],
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
