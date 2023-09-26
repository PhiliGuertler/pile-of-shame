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
    this.onTap,
  });
  final Color color;
  final String text;
  final bool isSelected;
  final double size;
  final Color? textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: SizedBox(
              width: size * 1.5,
              height: size * 1.2,
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
                end: const Offset(1.5, 1.2),
                duration: 250.ms,
                curve: Curves.easeInOutBack,
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
      ),
    );
  }
}
