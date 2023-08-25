import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/game_details/widgets/sliver_game_details.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
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
                title: game.when(
                  data: (game) => Text(game.name),
                  error: (error, stackTrace) => const Text('Error'),
                  loading: () => const Skeleton(),
                ),
              ),
              SliverGameDetails(
                gameId: widget.gameId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
