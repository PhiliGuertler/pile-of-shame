import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedRollingNumber extends ImplicitlyAnimatedWidget {
  final int value;
  final TextStyle? style;

  const AnimatedRollingNumber({
    super.key,
    super.curve,
    required this.value,
    required super.duration,
    this.style,
  });

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedRollingNumberState();
}

class _AnimatedRollingNumberState
    extends AnimatedWidgetBaseState<AnimatedRollingNumber> {
  Tween<double>? _value;

  int previousValue = 0;

  double computeOffsetProgress(double animationProgress, double difference) {
    final double offset = (difference * animationProgress * 2) % 2;
    return offset > 1.0 ? offset - 2.0 : offset;
  }

  @override
  Widget build(BuildContext context) {
    final double currentValue = _value?.evaluate(animation) ?? 0;
    final String number = currentValue.toStringAsFixed(0);

    final animationProgress = animation.value;
    // split the number into its digits
    final List<String> digits = number.runes
        .map(
          (e) => String.fromCharCode(e),
        )
        .toList();

    final List<Widget> animatedDigits = [];
    for (int i = 0; i < digits.length; ++i) {
      final digitPower = pow(10, digits.length - i - 1);
      final previousValueCap = previousValue ~/ digitPower;
      final currentValueCap = widget.value ~/ digitPower;
      final offsetProgress = computeOffsetProgress(
        animationProgress,
        (currentValueCap - previousValueCap).toDouble(),
      );
      final opacityProgress = 1.0 - offsetProgress.abs();

      final digit = digits[i];

      animatedDigits.add(
        Opacity(
          opacity: opacityProgress,
          child: Transform.translate(
            offset: Offset(0, offsetProgress * 15),
            child: Text(
              digit,
              style: widget.style,
              maxLines: 1,
            ),
          ),
        ),
      );
    }
    return Row(
      children: [
        ...animatedDigits,
      ],
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _value = visitor(
      _value,
      widget.value.toDouble(),
      (dynamic value) => Tween<double>(begin: value as double),
    )! as Tween<double>;
  }

  @override
  void didUpdateWidget(AnimatedRollingNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    previousValue = oldWidget.value;
  }
}
