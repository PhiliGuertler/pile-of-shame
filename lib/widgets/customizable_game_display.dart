import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/age_rating_text_display.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_image_container.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class CustomizableGameDisplay extends ConsumerWidget {
  final Game game;
  final VoidCallback onTap;

  const CustomizableGameDisplay({
    super.key,
    required this.game,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final dateFormatter = ref.watch(dateFormatProvider(context));

    final settings = ref.watch(customizeGameDisplaysProvider);

    Widget? leadingWidget;
    Widget? trailingWidget;
    Widget? secondaryWidget;

    settings.when(
        data: (settings) {
          switch (settings.leading) {
            case GameDisplayLeading.ageRatingIcon:
              leadingWidget = USKLogo.fromGame(game: game);
            case GameDisplayLeading.platformIcon:
              leadingWidget = GamePlatformIcon.fromGame(game: game);
            case GameDisplayLeading.playStatusIcon:
              leadingWidget = PlayStatusIcon.fromGame(
                game: game,
              );
            case GameDisplayLeading.none:
              leadingWidget = null;
          }
          switch (settings.trailing) {
            case GameDisplayTrailing.ageRatingIcon:
              trailingWidget = USKLogo.fromGame(game: game);
            case GameDisplayTrailing.platformIcon:
              trailingWidget = GamePlatformIcon.fromGame(game: game);
            case GameDisplayTrailing.playStatusIcon:
              trailingWidget = PlayStatusIcon.fromGame(
                game: game,
              );
            case GameDisplayTrailing.priceAndLastModified:
              trailingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currencyFormatter.format(game.fullPrice())),
                  Text(dateFormatter.format(game.lastModified)),
                ],
              );
            case GameDisplayTrailing.priceOnly:
              trailingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currencyFormatter.format(game.fullPrice())),
                ],
              );
            case GameDisplayTrailing.lastModifiedOnly:
              trailingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dateFormatter.format(game.lastModified)),
                ],
              );
            case GameDisplayTrailing.none:
              trailingWidget = null;
          }
          switch (settings.secondary) {
            case GameDisplaySecondary.statusText:
              secondaryWidget = PlayStatusDisplay.fromGame(game: game);
            case GameDisplaySecondary.ageRatingText:
              secondaryWidget = AgeRatingTextDisplay.fromGame(game: game);
            case GameDisplaySecondary.platformText:
              secondaryWidget = Text(
                  game.platform.localizedName(AppLocalizations.of(context)!));
            case GameDisplaySecondary.price:
              secondaryWidget =
                  Text(currencyFormatter.format(game.fullPrice()));
            case GameDisplaySecondary.none:
              secondaryWidget = null;
          }
        },
        error: (error, stackTrace) {},
        loading: () {
          trailingWidget = const ImageContainerSkeleton();
          leadingWidget = const ImageContainerSkeleton();
          secondaryWidget = const Skeleton();
        });

    const double favoriteSize = 32;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (game.isFavorite)
          const Positioned(
                  right: -favoriteSize * 0.4,
                  child: Icon(
                    Icons.favorite,
                    size: favoriteSize,
                    color: Colors.red,
                  ))
              .animate()
              .moveX(begin: favoriteSize, end: 0, curve: Curves.easeInOutBack),
        if (game.notes != null && game.notes!.isNotEmpty)
          Positioned(
            left: -favoriteSize * 0.4,
            child: Icon(
              Icons.note,
              size: favoriteSize,
              color: Theme.of(context).colorScheme.surfaceVariant,
            ).animate().moveX(
                begin: -favoriteSize, end: 0, curve: Curves.easeInOutBack),
          ),
        ListTile(
          title: Text(game.name),
          subtitle: secondaryWidget,
          leading: leadingWidget,
          trailing: trailingWidget,
          onTap: onTap,
        ),
      ],
    );
  }
}
