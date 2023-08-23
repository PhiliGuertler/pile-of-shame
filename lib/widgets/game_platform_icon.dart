import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

import 'image_container.dart';

class GamePlatformIcon extends StatelessWidget {
  final GamePlatform platform;

  const GamePlatformIcon({
    super.key,
    required this.platform,
  });

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      child: Image.asset(
        platform.iconPath,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
