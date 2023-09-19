import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedHeart extends StatelessWidget {
  final bool isReverse;
  final VoidCallback? onComplete;
  final int? seed;

  const AnimatedHeart(
      {super.key, required this.isReverse, this.onComplete, this.seed});

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

    final shakeDelay = generateRandomDoubleInRange(250.0, 450.0, rand);
    final moveDelay = generateRandomDoubleInRange(0.0, 250.0, rand);

    return const Icon(Icons.favorite, color: Colors.red)
        .animate(
          target: isReverse ? 0 : 1,
          onComplete: (controller) {
            if (onComplete != null) {
              onComplete!();
            }
          },
          autoPlay: false,
        )
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(0.0, 0.0),
          duration: 800.ms,
          curve: Curves.easeIn,
        )
        .moveY(
          begin: 0,
          end: -upwardsMovement,
          curve: Curves.easeInOut,
          delay: moveDelay.ms,
          duration: (800 - moveDelay).ms,
        )
        .shakeX(
          hz: shakeFrequency,
          amount: shakeAmount,
          curve: Curves.easeIn,
          delay: shakeDelay.ms,
          duration: (800 - shakeDelay).ms,
        )
        .fadeOut(duration: 800.ms);
  }
}
