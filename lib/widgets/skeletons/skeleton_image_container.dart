import 'package:flutter/material.dart';

import 'package:pile_of_shame/widgets/image_container.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';

class ImageContainerSkeleton extends StatelessWidget {
  final Duration? animationDuration;

  const ImageContainerSkeleton({super.key, this.animationDuration});

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      child: Skeleton(
        height: ImageContainer.imageSize,
        widthFactor: 1.0,
        animationDuration: animationDuration,
      ),
    );
  }
}
