import 'package:flutter/material.dart';

class ProgressingIcon extends StatelessWidget {
  const ProgressingIcon({
    super.key,
    required this.progress,
    required this.icon,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.iconSize = 32.0,
  });

  final IconData icon;
  final double progress;
  final double iconSize;
  final Color backgroundColor;
  final Color foregroundColor;

  // delays the linear interpolation from 0-1 by begin, which maps
  // [0, begin] -> [0,0] and [begin, 1] -> [0,1]
  double lerpFactor(double begin) {
    return (-begin / (1 - begin) + progress * 1 / (1 - begin)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Color.lerp(backgroundColor, foregroundColor, lerpFactor(0.25)),
        ),
        Padding(
          padding: EdgeInsets.only(right: iconSize - progress * iconSize),
          child: ClipRect(
            child: SizedBox(
              width: progress * iconSize,
              child: Icon(
                icon,
                size: iconSize,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
