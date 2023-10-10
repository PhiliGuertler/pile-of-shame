import 'package:flutter/material.dart';

enum Breakpoints {
  sm(minWidth: 0.0, numColumns: 1),
  md(minWidth: 350.0, numColumns: 1),
  lg(minWidth: 750.0, numColumns: 2),
  xl(minWidth: 1050.0, numColumns: 3),
  ;

  final double minWidth;
  final int numColumns;

  const Breakpoints({required this.minWidth, required this.numColumns});

  static Breakpoints of(BuildContext context) {
    final query = MediaQuery.of(context);
    final maxWidth = query.size.width;
    for (int i = Breakpoints.values.length - 1; i >= 0; --i) {
      final Breakpoints point = Breakpoints.values[i];
      if (point.minWidth < maxWidth) {
        return point;
      }
    }
    return Breakpoints.sm;
  }
}
