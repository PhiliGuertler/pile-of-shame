import 'package:flutter/material.dart';

class AnimatedCurrency extends ImplicitlyAnimatedWidget {
  final double currency;
  final String Function(double value) formatCurrency;
  final TextStyle? style;

  const AnimatedCurrency({
    super.key,
    super.curve,
    required this.currency,
    required super.duration,
    required this.formatCurrency,
    this.style,
  });

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCurrencyState();
}

class _AnimatedCurrencyState extends AnimatedWidgetBaseState<AnimatedCurrency> {
  Tween<double>? _count;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.formatCurrency(_count?.evaluate(animation) ?? 0),
      style: widget.style,
      maxLines: 1,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _count = visitor(
      _count,
      widget.currency,
      (dynamic value) => Tween<double>(begin: value as double),
    )! as Tween<double>;
  }
}
