import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedHeart extends StatelessWidget {
  final bool isReverse;
  final VoidCallback? onComplete;
  final int? seed;
  final Color color;

  const AnimatedHeart({
    super.key,
    required this.isReverse,
    this.onComplete,
    this.seed,
    this.color = Colors.red,
  });

  double generateRandomDoubleInRange(double min, double max, Random rand) {
    return (max - min) * rand.nextDouble() + min;
  }

  double generateRandomSign(Random rand) {
    return rand.nextBool() ? 1 : -1;
  }

  @override
  Widget build(BuildContext context) {
    final Random rand = Random(seed);

    final shakeFrequency = generateRandomDoubleInRange(1.0, 2.0, rand);
    final shakeAmount = generateRandomSign(rand) *
        generateRandomDoubleInRange(10.0, 15.0, rand);
    final upwardsMovement = generateRandomDoubleInRange(35.0, 45.0, rand);

    final scaleDelay = generateRandomDoubleInRange(250.0, 450.0, rand);
    final shakeDelay = generateRandomDoubleInRange(150.0, 350.0, rand);
    final moveDelay = generateRandomDoubleInRange(400.0, 500.0, rand);

    return Icon(Icons.favorite, color: color)
        .animate(
          target: isReverse ? 1 : 0,
          onComplete: (controller) {
            if (onComplete != null) {
              onComplete?.call();
            }
          },
        )
        .scale(
          begin: Offset.zero,
          end: const Offset(1.0, 1.0),
          delay: scaleDelay.ms,
          duration: (800 - scaleDelay).ms,
          curve: Curves.easeOut,
        )
        .moveY(
          begin: -upwardsMovement,
          end: 0,
          curve: Curves.easeInOut,
          delay: moveDelay.ms,
          duration: (800 - moveDelay).ms,
        )
        .shakeX(
          hz: shakeFrequency,
          amount: shakeAmount,
          curve: Curves.easeOut,
          delay: shakeDelay.ms,
          duration: (800 - shakeDelay).ms,
        )
        .fadeIn(duration: 800.ms);
  }
}
