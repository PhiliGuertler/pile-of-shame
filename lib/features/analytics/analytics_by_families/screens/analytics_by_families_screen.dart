import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/widgets/analytics_details.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';

class AnalyticsByFamiliesScreen extends ConsumerWidget {
  const AnalyticsByFamiliesScreen({super.key, this.family});

  final GamePlatformFamily? family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    late AsyncValue<List<Game>> games;
    if (family == null) {
      games = ref.watch(gamesProvider);
    } else {
      games = ref.watch(gamesByPlatformFamilyProvider(family!));
    }

    return AppScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFancyImageAppBar(
            borderRadius: -defaultBorderRadius * 2,
            imagePath: family?.image.value ?? ImageAssets.library.value,
            title: Text(
              family != null ? family!.toLocale(l10n) : l10n.gameLibrary,
            ),
          ),
          games.when(
            data: (games) => SliverAnalyticsDetails(games: games),
            error: (error, stackTrace) => SliverToBoxAdapter(
              child: Text(error.toString()),
            ),
            loading: () => const SliverAnalyticsDetailsSkeleton(),
          ),
        ],
      ),
    );
  }
}
