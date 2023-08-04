import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

class GamePlatformIcon extends StatelessWidget {
  final GamePlatforms platform;
  final double width;
  final double height;

  const GamePlatformIcon({
    super.key,
    required this.platform,
    this.width = 70.0,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Image.asset(platform.iconPath),
      ),
    );
  }
}
