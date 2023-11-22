import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  static const double imageSize = 45.0;
  static const double borderRadius = 8.0;

  final Widget? child;
  final Color? backgroundColor;

  const ImageContainer({super.key, this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      child: Container(
        width: imageSize,
        height: imageSize,
        color: backgroundColor ??
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        child: Center(child: child),
      ),
    );
  }
}
