import 'package:flutter/material.dart';

class AnimatedNumberText extends ImplicitlyAnimatedWidget {
  final double number;
  final String Function(double value) formatNumber;
  final TextStyle? style;

  const AnimatedNumberText({
    super.key,
    super.curve,
    required this.number,
    required super.duration,
    required this.formatNumber,
    this.style,
  });

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedNumberText();
}

class _AnimatedNumberText extends AnimatedWidgetBaseState<AnimatedNumberText> {
  Tween<double>? _count;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.formatNumber(_count?.evaluate(animation) ?? 0),
      style: widget.style,
      maxLines: 1,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _count = visitor(
      _count,
      widget.number,
      (dynamic value) => Tween<double>(begin: value as double),
    )! as Tween<double>;
  }
}
