import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/widgets/animated_sparkle/star_painter.dart';

class AnimatedSparkle extends StatelessWidget {
  AnimatedSparkle({super.key, required this.controller, this.colorHue = 0})
      : animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0, curve: Curves.ease),
          ),
        );

  final AnimationController controller;
  final Animation<double> animation;
  final double colorHue;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(
            sizeFactor: animation.value,
            colorHue: colorHue,
          ),
        );
      },
    );
  }
}
