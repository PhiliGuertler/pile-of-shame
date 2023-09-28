import 'package:flutter/material.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';

import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_image_container.dart';

class SkeletonGameDisplay extends StatelessWidget {
  static const Duration animationDuration = Duration(milliseconds: 800);

  const SkeletonGameDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: ImageContainerSkeleton(
        animationDuration: animationDuration,
      ),
      title: Padding(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Skeleton(
          animationDuration: animationDuration,
        ),
      ),
      subtitle: Skeleton(
        height: PlayStatusDisplay.height,
        widthFactor: 1.0,
        animationDuration: animationDuration,
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
                alignment: Alignment.centerRight,
                animationDuration: animationDuration,
              ),
            ),
            Skeleton(
              widthFactor: 1.0,
              animationDuration: animationDuration,
            ),
          ],
        ),
      ),
    );
  }
}
