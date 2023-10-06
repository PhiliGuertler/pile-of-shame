import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/slivers/sliver_grouped_games.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';

class PlatformGameListScreen extends ConsumerWidget {
  const PlatformGameListScreen({super.key, required this.platform});

  final GamePlatform platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final games = ref.watch(gamesByPlatformProvider(platform));

    return AppScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFancyImageAppBar(
            imagePath: platform.controllerLogoPath,
            title: Text(platform.localizedName(l10n)),
            borderRadius: -defaultBorderRadius * 2.0,
          ),
          games.when(
            data: (games) => SliverGroupedGames(games: games),
            loading: () => SliverList.builder(
              itemBuilder: (context, index) => const SkeletonGameDisplay()
                  .animate()
                  .fade(curve: Curves.easeOut, duration: 130.ms),
              itemCount: 10,
            ),
            error: (error, stackTrace) => SliverToBoxAdapter(
              child: Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
