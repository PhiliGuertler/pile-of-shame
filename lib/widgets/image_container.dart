import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  static const double imageSize = 45.0;

  final Widget? child;

  const ImageContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
      child: Container(
        width: imageSize,
        height: imageSize,
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        child: Center(child: child),
      ),
    );
  }
}
