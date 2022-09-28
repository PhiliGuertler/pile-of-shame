import 'dart:math';

import 'package:flutter/material.dart';

class RandomStar {
  RandomStar(AnimationController controller,
      {double maxWidth = 1, double maxHeight = 1})
      : colorHue = 0,
        size = const Size(0, 0),
        offset = const Offset(0, 0),
        animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0, 1, curve: Curves.linear),
          ),
        ),
        rotationAngle = 0 {
    final double randomColorHueValue = Random().nextDouble();
    final double randomSize = Random().nextDouble() * 5 + 5;
    final double randomOffsetX = Random().nextDouble() * 1.1 - 0.05;
    final double randomOffsetY = Random().nextDouble() * 1.1 - 0.05;
    final double randomAnimation1 = Random().nextDouble();
    final double randomAnimation2 = Random().nextDouble();
    final double randomRotation = Random().nextDouble();

    colorHue = randomColorHueValue;
    size = Size(randomSize, randomSize);
    offset = Offset(
      randomOffsetX * maxWidth - randomSize * 0.5,
      randomOffsetY * maxHeight - randomSize * 0.5,
    );
    final double minAnimationValue = min(randomAnimation1, randomAnimation2);
    final double maxAnimationValue = max(randomAnimation1, randomAnimation2);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve:
            Interval(minAnimationValue, maxAnimationValue, curve: Curves.ease),
      ),
    );
    rotationAngle = randomRotation * pi * 0.5;
  }

  double colorHue;
  Size size;
  Offset offset;
  double rotationAngle;
  Animation<double> animation;
}
