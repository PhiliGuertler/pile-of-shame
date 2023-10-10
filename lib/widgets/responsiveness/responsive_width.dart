import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/responsiveness/breakpoints.dart';

class ResponsiveWidth extends StatelessWidget {
  const ResponsiveWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > Breakpoints.lg.minWidth) {
          return SizedBox(
            width: 780 * 0.49,
            child: child,
          );
        }
        return child;
      },
    );
  }
}
