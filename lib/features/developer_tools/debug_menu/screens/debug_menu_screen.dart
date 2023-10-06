import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/features/developer_tools/debug_game_platform_icons/screens/debug_game_platform_icons_screen.dart';
import 'package:pile_of_shame/features/developer_tools/debug_platform_family_cards/screens/debug_platform_family_cards_screen.dart';
import 'package:pile_of_shame/features/developer_tools/debug_swipe_to_trigger/screens/debug_swipe_to_trigger_screen.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/animated/animated_rolling_number.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/image_list_tile.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

Stream<int> randomIntStream() async* {
  final Random random = Random();

  do {
    yield random.nextInt(1000);
    await Future.delayed(2.seconds);
  } while (true);
}

class DebugMenuScreen extends StatelessWidget {
  const DebugMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text("Debug Menu"),
      ),
      body: StreamBuilder<int>(
        stream: randomIntStream(),
        builder: (context, snapshot) {
          return SafeArea(
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
                      title: const Text("Image Assets"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const DebugImageAssetsScreen(),
                          ),
                        );
                      },
                    ),
                    SegmentedActionCardItem(
                      leading: const Icon(Icons.sports_esports),
                      title: const Text("Swipe to Trigger"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const DebugSwipeToTriggerScreen(),
                          ),
                        );
                      },
                    ),
                    SegmentedActionCardItem(
                      leading: const Icon(Icons.sports_esports),
                      title: const Text("Platform-Family Cards"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const DebugPlatformFamilyCardsScreen(),
                          ),
                        );
                      },
                    ),
                    SegmentedActionCardItem(
                      title: AnimatedRollingNumber(
                        value: snapshot.data ?? 0,
                        duration: 350.ms,
                      ),
                      subtitle: Text((snapshot.data ?? 0).toStringAsFixed(0)),
                      trailing: const SizedBox(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: defaultPaddingX,
                    right: defaultPaddingX,
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: ImageListTile(
                    imagePath: ImageAssets.controllerGameCube.value,
                    heroTag: "GCN",
                    title: const Text("Title"),
                    subtitle: const Text("Subtitle"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
