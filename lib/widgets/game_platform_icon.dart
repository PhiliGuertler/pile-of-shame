import 'package:flutter/material.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/widgets/fade_in_image_asset.dart';

class GamePlatformIcon extends StatelessWidget {
  final GamePlatform platform;

  const GamePlatformIcon({
    super.key,
    required this.platform,
  });

  GamePlatformIcon.fromGame({super.key, required Game game})
      : platform = game.platform;

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FadeInImageAsset(
          asset: platform.icon,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
