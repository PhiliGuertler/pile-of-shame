import 'package:flutter/material.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';

import 'skeleton.dart';
import 'skeleton_image_container.dart';

class SkeletonGameDisplay extends StatelessWidget {
  const SkeletonGameDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: ImageContainerSkeleton(),
      title: Padding(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Skeleton(),
      ),
      subtitle: Skeleton(
        height: PlayStatusDisplay.height,
        widthFactor: 1.0,
      ),
      trailing: SizedBox(
        width: 50.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Skeleton(
                widthFactor: 0.7,
                alignment: Alignment.centerRight,
              ),
            ),
            Skeleton(
              widthFactor: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
