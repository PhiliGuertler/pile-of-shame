import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/widgets/animated_sparkle/star_painter.dart';

import 'random_star.dart';

class AnimatedSparkle extends StatelessWidget {
  const AnimatedSparkle({super.key, this.star});

  final RandomStar? star;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: star?.size.width ?? 0,
      height: star?.size.height ?? 0,
      child: Transform.translate(
        offset: star?.offset ?? Offset.zero,
        child: Transform.rotate(
          angle: star?.rotationAngle ?? 0,
          child: CustomPaint(
            painter: StarPainter(
              sizeFactor: sin(star?.animation.value ?? 0),
              colorHue: star?.colorHue ?? 0,
              maxOvershot: 15,
            ),
          ),
        ),
      ),
    );
  }
}
