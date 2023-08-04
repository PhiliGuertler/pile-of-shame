import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';

class DebugGamePlatformsScreens extends StatelessWidget {
  const DebugGamePlatformsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Debug Game Platforms")),
      body: SafeArea(
        child: CustomScrollView(
          slivers: GamePlatforms.values
              .map(
                (platform) => SliverToBoxAdapter(
                  key: ValueKey(platform.index),
                  child: ListTile(
                    title: Text(platform.name),
                    subtitle: Text(platform.abbreviation),
                    leading: GamePlatformIcon(platform: platform),
                    trailing: Image.asset(platform.textLogoPath),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
