import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Skeleton extends StatelessWidget {
  static const Duration defaultAnimationDuration = Duration(milliseconds: 1200);

  final Duration animationDuration;
  final double widthFactor;
  final double height;
  final Alignment alignment;
  final double borderRadius;

  const Skeleton({
    super.key,
    this.widthFactor = 0.7,
    this.height = 20,
    this.alignment = Alignment.centerLeft,
    this.borderRadius = 8,
    Duration? animationDuration,
  }) : animationDuration = animationDuration ?? defaultAnimationDuration;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              duration: animationDuration,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            )
            .animate()
            .fadeIn(
              duration: Duration(
                milliseconds: (animationDuration.inMilliseconds * 0.5).toInt(),
              ),
            ),
      ),
    );
  }
}
