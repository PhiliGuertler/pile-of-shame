import 'package:flutter/material.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

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
