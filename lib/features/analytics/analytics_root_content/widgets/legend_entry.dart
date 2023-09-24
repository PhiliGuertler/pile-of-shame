import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LegendEntry extends StatelessWidget {
  const LegendEntry({
    super.key,
    required this.color,
    required this.text,
    required this.isSelected,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSelected;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: SizedBox(
            width: size * 1.5,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: color,
                ),
              ),
            ),
          ),
        )
            .animate(
              target: isSelected ? 1 : 0,
            )
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(2.4, 1.2),
              duration: 150.ms,
              curve: Curves.easeInOut,
            )
            .swap(
              builder: (context, child) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Container(
                  width: size * 1.5,
                  height: size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: color,
                  ),
                ),
              ).animate().scale(
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(1.0, 1.0),
                    duration: 150.ms,
                    curve: Curves.easeInOut,
                  ),
            ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
