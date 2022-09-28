import 'dart:math';
import 'package:flutter/material.dart';

class StarPainter extends CustomPainter {
  StarPainter({required this.sizeFactor, this.colorHue = 0});

  final double sizeFactor;
  final double colorHue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = HSVColor.fromAHSV(1.0, colorHue * 255.0, 1.0, 1.0).toColor();
    paint.strokeWidth = 3.0 * (sizeFactor * 0.5 + 0.5);
    paint.strokeCap = StrokeCap.round;

    const double starRadius = 30.0;
    final Radius radius =
        Radius.circular((sizeFactor * 0.5 + 0.5) * starRadius);

    final path = Path();
    path.moveTo((1 - sizeFactor) * size.width * 0.5, size.height * 0.5);
    path.arcToPoint(
      Offset(size.width * 0.5, (1 - sizeFactor) * size.height * 0.5),
      radius: radius,
      clockwise: false,
    );
    path.arcToPoint(
      Offset(size.width * (sizeFactor * 0.5 + 0.5), size.height * 0.5),
      radius: radius,
      clockwise: false,
    );
    path.arcToPoint(
      Offset(
        size.width * 0.5,
        size.height * (0.5 * sizeFactor + 0.5),
      ),
      radius: radius,
      clockwise: false,
    );
    path.arcToPoint(
      Offset((1 - sizeFactor) * size.width * 0.5, size.height * 0.5),
      clockwise: false,
      radius: radius,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) {
    return sizeFactor != oldDelegate.sizeFactor ||
        colorHue != oldDelegate.colorHue;
  }
}
