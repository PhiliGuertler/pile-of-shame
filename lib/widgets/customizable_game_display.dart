import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/age_rating_text_display.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

enum GameDisplayLeading {
  platformIcon,
  playStatusIcon,
  ageRatingIcon,
  none,
}

enum GameDisplayTrailing {
  priceOnly,
  lastModifiedOnly,
  priceAndLastModified,
  platformIcon,
  playStatusIcon,
  ageRatingIcon,
  none,
}

enum GameDisplaySecondary {
  statusText,
  platformText,
  price,
  ageRatingText,
  none,
}

class CustomizableGameDisplay extends ConsumerWidget {
  final Game game;
  final GameDisplayLeading leading;
  final GameDisplayTrailing trailing;
  final GameDisplaySecondary secondary;
  final VoidCallback onTap;

  const CustomizableGameDisplay({
    super.key,
    required this.game,
    this.leading = GameDisplayLeading.platformIcon,
    this.trailing = GameDisplayTrailing.priceAndLastModified,
    this.secondary = GameDisplaySecondary.statusText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final dateFormatter = ref.watch(dateFormatProvider(context));
    Widget? leadingWidget;
    switch (leading) {
      case GameDisplayLeading.ageRatingIcon:
        leadingWidget = USKLogo.fromGame(game: game);
      case GameDisplayLeading.platformIcon:
        leadingWidget = GamePlatformIcon.fromGame(game: game);
      case GameDisplayLeading.playStatusIcon:
        leadingWidget = PlayStatusIcon.fromGame(game: game);
      case GameDisplayLeading.none:
        leadingWidget = null;
    }

    Widget? trailingWidget;
    switch (trailing) {
      case GameDisplayTrailing.ageRatingIcon:
        trailingWidget = USKLogo.fromGame(game: game);
      case GameDisplayTrailing.platformIcon:
        trailingWidget = GamePlatformIcon.fromGame(game: game);
      case GameDisplayTrailing.playStatusIcon:
        trailingWidget = PlayStatusIcon.fromGame(game: game);
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

    Widget? secondaryWidget;
    switch (secondary) {
      case GameDisplaySecondary.statusText:
        secondaryWidget = PlayStatusDisplay.fromGame(game: game);
      case GameDisplaySecondary.ageRatingText:
        secondaryWidget = AgeRatingTextDisplay.fromGame(game: game);
      case GameDisplaySecondary.platformText:
        secondaryWidget = Text(game.platform.name);
      case GameDisplaySecondary.price:
        secondaryWidget = Text(currencyFormatter.format(game.fullPrice()));
      case GameDisplaySecondary.none:
        secondaryWidget = null;
    }

    return ListTile(
      title: Text(game.name),
      subtitle: secondaryWidget,
      leading: leadingWidget,
      trailing: trailingWidget,
      onTap: onTap,
    );
  }
}
