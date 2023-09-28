import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class USKLogo extends ConsumerWidget {
  final USK ageRestriction;

  const USKLogo({super.key, required this.ageRestriction});

  USKLogo.fromGame({super.key, required Game game}) : ageRestriction = game.usk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(customizeGameDisplaysProvider);

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
        fontSize: 15.0,
      ),
    );
    settings.maybeWhen(
      data: (settings) {
        if (settings.hasFancyAnimations) {
          final Animate result = ageText
              .animate(
                onPlay: settings.hasRepeatingAnimations
                    ? (controller) => controller.repeat(reverse: true)
                    : null,
              )
              .then(
                delay: settings.hasRepeatingAnimations
                    ? animationWaitDuration
                    : 0.ms,
              )
              .scale(
                begin: const Offset(1.0 / 2.0, 1.0 / 2.0),
                end: const Offset(1.0, 1.0),
                duration: animationDuration,
                curve: Curves.easeInOutBack,
              )
              .rotate(begin: -0.2, end: 0.0)
              .then(delay: animationWaitDuration);
          ageText = result;
        }
      },
      orElse: () {},
    );

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
    settings.maybeWhen(
      data: (settings) {
        if (settings.hasFancyAnimations) {
          final Animate result = clippedRectangle
              .animate(
                onPlay: settings.hasRepeatingAnimations
                    ? (controller) => controller.repeat(reverse: true)
                    : null,
              )
              .then(
                delay: settings.hasRepeatingAnimations
                    ? animationWaitDuration
                    : 0.ms,
              )
              .scale(
                begin: const Offset(2.0, 2.0),
                end: const Offset(1.0, 1.0),
                duration: animationDuration,
                curve: Curves.easeInOutBack,
              )
              .rotate(begin: 0.2, end: 0.0)
              .then(delay: animationWaitDuration);

          clippedRectangle = result;
        }
      },
      orElse: () {},
    );

    return SizedBox(
      width: ImageContainer.imageSize,
      height: ImageContainer.imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ColoredBox(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade300
              : Colors.grey.shade700,
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
      ),
    );
  }
}
