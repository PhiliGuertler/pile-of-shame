import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/utils/constants.dart';

class DebugGameControllerAssetsScreen extends StatefulWidget {
  const DebugGameControllerAssetsScreen({super.key});

  @override
  State<DebugGameControllerAssetsScreen> createState() =>
      _DebugGameControllerAssetsScreenState();
}

class _DebugGameControllerAssetsScreenState
    extends State<DebugGameControllerAssetsScreen> {
  bool shouldDisplayLightAsset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Controller Assets"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                shouldDisplayLightAsset = !shouldDisplayLightAsset;
              });
            },
            icon: Icon(
                shouldDisplayLightAsset ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemBuilder: (context, index) {
                final platform = GamePlatform.values[index];
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: defaultPaddingX,
                        right: defaultPaddingX,
                        top: 16.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        platform.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: Image.asset(
                        shouldDisplayLightAsset
                            ? platform.controllerLogoPathLight
                            : platform.controllerLogoPathDark,
                      ),
                    )
                  ],
                );
              },
              itemCount: GamePlatform.values.length,
            ),
          ],
        ),
      ),
    );
  }
}
