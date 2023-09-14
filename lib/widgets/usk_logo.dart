import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

import '../models/game.dart';

class USKLogo extends StatelessWidget {
  final USK ageRestriction;
  final bool hasAnimation;
  final bool hasRepeatingAnimation;

  const USKLogo({
    super.key,
    required this.ageRestriction,
    this.hasAnimation = true,
    this.hasRepeatingAnimation = true,
  });

  USKLogo.fromGame({
    super.key,
    required Game game,
    this.hasAnimation = true,
    this.hasRepeatingAnimation = true,
  }) : ageRestriction = game.usk;

  @override
  Widget build(BuildContext context) {
    final ageRestrictionColor = ageRestriction.color;
    final ageRestrictionText = ageRestriction.age.toString();

    const Duration animationDuration = Duration(seconds: 2);
    const Duration animationWaitDuration = Duration(seconds: 1);

    Widget ageText = Text(
      ageRestrictionText,
      style: TextStyle(
          color: ageRestrictionColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15.0),
    );
    if (hasAnimation) {
      ageText = ageText
          .animate(
            onPlay: hasRepeatingAnimation
                ? (controller) => controller.repeat(reverse: true)
                : null,
          )
          .then(delay: animationWaitDuration)
          .scale(
            begin: const Offset(1.0 / 2.0, 1.0 / 2.0),
            end: const Offset(1.0, 1.0),
            duration: animationDuration,
            curve: Curves.easeInOutBack,
          )
          .rotate(begin: -0.2, end: 0.0)
          .then(delay: animationWaitDuration);
    }

    Widget clippedRectangle = ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: SizedBox(
        width: ImageContainer.imageSize * 0.75,
        height: ImageContainer.imageSize * 0.75,
        child: ColoredBox(
          color: ageRestrictionColor,
          child: Transform.rotate(
            angle: -pi * 0.25,
            child: Center(
              child: ageText,
            ),
          ),
        ),
      ),
    );
    if (hasAnimation) {
      clippedRectangle = clippedRectangle
          .animate(
            onPlay: hasRepeatingAnimation
                ? (controller) => controller.repeat(reverse: true)
                : null,
          )
          .then(delay: animationWaitDuration)
          .scale(
            begin: const Offset(2.0, 2.0),
            end: const Offset(1.0, 1.0),
            duration: animationDuration,
            curve: Curves.easeInOutBack,
          )
          .rotate(begin: 0.2, end: 0.0)
          .then(delay: animationWaitDuration);
    }

    return SizedBox(
      width: ImageContainer.imageSize,
      height: ImageContainer.imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ColoredBox(
          color: ageRestrictionColor.withOpacity(0.5),
          child: Center(
            child: Transform.rotate(
              angle: pi * 0.25,
              child: clippedRectangle,
            ),
          ),
        ),
      ),
    );
  }
}
