import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/developer_tools/debug_game_controller_assets/screens/debug_game_controller_assets_screen.dart';
import 'package:pile_of_shame/features/developer_tools/debug_game_controller_shader/screens/debug_game_controller_shader_screen.dart';
import 'package:pile_of_shame/features/developer_tools/debug_game_platform_icons/screens/debug_game_platform_icons_screen.dart';
import 'package:pile_of_shame/features/developer_tools/debug_game_platform_text_logos/screens/debug_game_platform_text_logos_screen.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

class DebugMenuScreen extends StatelessWidget {
  const DebugMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text("Debug Menu"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: defaultPaddingX,
                right: defaultPaddingX,
                top: 16.0,
                bottom: 8.0,
              ),
              child: Text(
                "Game",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SegmentedActionCard(
              items: [
                SegmentedActionCardItem(
                  leading: const Icon(Icons.image),
                  title: const Text("Game-Platform Icons"),
                  subtitle: const Text("Display all Game-Platform Icon assets"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const DebugGamePlatformIconsScreen(),
                    ));
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.text_format),
                  title: const Text("Game-Platform Text-Logos"),
                  subtitle:
                      const Text("Display all Game-Platform Text-Logo assets"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const DebugGamePlatformTextLogosScreen(),
                    ));
                  },
                ),
                SegmentedActionCardItem.debug(
                  leading: const Icon(Icons.sports_esports),
                  title: const Text("Game-Platform Controllers"),
                  subtitle:
                      const Text("Display all Game-Platform Controller assets"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const DebugGameControllerAssetsScreen(),
                    ));
                  },
                ),
                SegmentedActionCardItem.debug(
                  leading: const Icon(Icons.bolt),
                  title: const Text("Game-Platform Controllers"),
                  subtitle: const Text("Display a fancy shader"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DebugGameControllerShaderScreen(),
                    ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
