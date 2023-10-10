import 'package:flutter/material.dart';
import 'package:pile_of_shame/widgets/responsiveness/responsive_width.dart';

class ResponsiveWrap extends StatelessWidget {
  const ResponsiveWrap({
    super.key,
    required this.children,
    this.alignment = WrapAlignment.spaceEvenly,
  });

  final List<Widget> children;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      runSpacing: 16.0,
      spacing: 16.0,
      children: children.map((e) => ResponsiveWidth(child: e)).toList(),
    );
  }
}
