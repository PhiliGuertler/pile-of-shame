import 'dart:math' as math;
import 'package:flutter/material.dart';

class StarPainter extends CustomPainter {
  StarPainter(
      {required this.sizeFactor, this.colorHue = 0, this.maxOvershot = 0});

  final double sizeFactor;
  final double colorHue;
  final double maxOvershot;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = HSVColor.fromAHSV(1.0, colorHue * 255.0, 0.2, 1.0).toColor();
    paint.strokeWidth = 3.0 * (sizeFactor * 0.5 + 0.5);
    paint.strokeCap = StrokeCap.round;

    final double starRadius =
        math.sqrt(size.width * size.width + size.height * size.height) -
            math.min((size.width * 0.5 - size.height * 0.5).abs(), maxOvershot);
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
