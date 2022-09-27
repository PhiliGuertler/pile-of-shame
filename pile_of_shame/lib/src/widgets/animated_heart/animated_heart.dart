import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedHeart extends StatelessWidget {
  AnimatedHeart({
    super.key,
    required this.controller,
    required this.random1,
    required this.random2,
    required this.maxHeight,
    required this.maxWidth,
  })  : move = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(random1 * 0.4, 1.0, curve: Curves.linear))),
        up = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(random1 * 0.4, 1.0, curve: Curves.ease)));

  final Animation<double> move;
  final Animation<double> up;
  final AnimationController controller;
  final double random1;
  final double random2;
  final double maxWidth;
  final double maxHeight;

  final double iconWidth = 24;
  final double iconHeight = 24;

  double computeXOffset(double upValue, double moveValue) {
    return (random2 - 0.5).sign *
        sin(moveValue * random2 * 15) *
        (1 - upValue) *
        (random1 * (maxWidth - iconWidth * 2) * 0.6 +
            (maxWidth - iconWidth * 2) * 0.4);
  }

  double computeYOffset(double upValue, double moveValue) {
    return -upValue *
        (random2 * (maxHeight - iconHeight - 8) * 0.4 +
            (maxHeight - iconHeight - 8) * 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(computeXOffset(up.value, move.value),
              computeYOffset(up.value, move.value)),
          child: Transform.scale(
            scale: 1 - up.value,
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}
