import 'package:flutter/material.dart';

import '../image_container.dart';
import 'skeleton.dart';

class ImageContainerSkeleton extends StatelessWidget {
  const ImageContainerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageContainer(
      child: Skeleton(
        height: ImageContainer.imageSize,
        widthFactor: 1.0,
      ),
    );
  }
}
