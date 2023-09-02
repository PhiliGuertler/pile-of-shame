import 'package:flutter/material.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

class DebugMenuScreen extends StatelessWidget {
  const DebugMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    throw UnimplementedError();
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.text_format),
                  title: const Text("Game-Platform Text-Logos"),
                  subtitle:
                      const Text("Display all Game-Platform Text-Logo assets"),
                  onTap: () {
                    throw UnimplementedError();
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.sports_esports),
                  title: const Text("Game-Platform Controllers"),
                  subtitle:
                      const Text("Display all Game-Platform Controller assets"),
                  onTap: () {
                    throw UnimplementedError();
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
