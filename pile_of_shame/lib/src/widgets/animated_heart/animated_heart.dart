import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedHeart extends StatelessWidget {
  AnimatedHeart(
      {super.key,
      required this.controller,
      required this.random1,
      required this.random2})
      : move = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Positioned(
          left: (150 - 12) +
              (random2 - 0.5).sign *
                  sin(move.value * random2 * 15) *
                  (1 - up.value) *
                  (random1 * 30 + 20),
          bottom: (150 - 12) + up.value * (random2 * 40 + 60),
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
