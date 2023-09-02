import 'dart:ui';

import 'package:flutter/material.dart';

class GameControllerPainter extends CustomPainter {
  final FragmentShader shader;
  final double x;
  final double y;

  const GameControllerPainter(
      {required this.shader, required this.x, required this.y});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(2, x);
    shader.setFloat(3, y);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant GameControllerPainter oldDelegate) {
    return oldDelegate.shader != shader ||
        oldDelegate.x != x ||
        oldDelegate.y != y;
  }
}
