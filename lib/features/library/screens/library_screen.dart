import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/screens/analytics_by_families_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/parallax_image_card.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformFamilies =
        ref.watch(gamePlatformFamiliesWithSavedGamesProvider);

    return platformFamilies.when(
      data: (families) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
              vertical: 8.0,
            ),
            child: ParallaxImageCard(
              imagePath: ImageAssets.library.value,
              title: AppLocalizations.of(context)!.gameLibrary,
              openBuilderOnTap: (context, openContainer) =>
                  const AnalyticsByFamiliesScreen(),
            ),
          ),
          for (final family in families)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: ParallaxImageCard(
                imagePath: family.image.value,
                title: family.toLocale(AppLocalizations.of(context)!),
                openBuilderOnTap: (context, openContainer) =>
                    AnalyticsByFamiliesScreen(family: family),
              ),
            ),
          const SizedBox(
            height: 24.0,
          ),
        ],
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => ListView(),
    );
  }
}
