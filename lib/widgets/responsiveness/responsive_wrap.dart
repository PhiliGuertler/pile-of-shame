import 'package:flutter/material.dart';
import 'package:pile_of_shame/widgets/responsiveness/responsive_width.dart';

class ResponsiveWrap extends StatelessWidget {
  const ResponsiveWrap({
    super.key,
    required this.children,
    this.alignment = WrapAlignment.start,
  });

  final List<Widget> children;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      children: children.map((e) => ResponsiveWidth(child: e)).toList(),
    );
  }
}
