import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/parallax_image_card.dart';

class DebugPlatformFamilyCardsScreen extends StatelessWidget {
  const DebugPlatformFamilyCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text("Platform Family Cards")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: defaultPaddingX,
            ),
            child: ParallaxImageCard(
              imagePath: ImageAssets.platformFamilyMicrosoft.value,
              title: "Microsoft",
              onTap: () {
                debugPrint("Lets gooo");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: defaultPaddingX,
            ),
            child: ParallaxImageCard(
              imagePath: ImageAssets.platformFamilyNintendo.value,
              title: "Nintendo",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: defaultPaddingX,
            ),
            child: ParallaxImageCard(
              imagePath: ImageAssets.platformFamilyMisc.value,
              title: "Misc",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: defaultPaddingX,
            ),
            child: ParallaxImageCard(
              imagePath: ImageAssets.platformFamilyPC.value,
              title: "PC",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: defaultPaddingX,
            ),
            child: ParallaxImageCard(
              imagePath: ImageAssets.platformFamilySega.value,
              title: "SEGA",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: defaultPaddingX,
            ),
            child: ParallaxImageCard(
              imagePath: ImageAssets.platformFamilySony.value,
              title: "Sony",
            ),
          ),
        ],
      ),
    );
  }
}
