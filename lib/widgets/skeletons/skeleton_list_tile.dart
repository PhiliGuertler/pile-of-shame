import 'package:flutter/material.dart';

import 'skeleton.dart';
import 'skeleton_image_container.dart';

class ListTileSkeleton extends StatelessWidget {
  final bool hasLeading;
  final bool hasSubtitle;

  const ListTileSkeleton(
      {super.key, this.hasLeading = true, this.hasSubtitle = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Skeleton(
        widthFactor: 0.5,
      ),
      subtitle: hasSubtitle
          ? const Skeleton(
              widthFactor: 0.3,
              height: 13.0,
            )
          : null,
      leading: hasLeading
          ? const ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
              child: ImageContainerSkeleton(),
            )
          : null,
    );
  }
}
