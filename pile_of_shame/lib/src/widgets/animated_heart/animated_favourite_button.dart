import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/widgets/animated_heart/animated_heart.dart';

class AnimatedFavouriteButton extends StatefulWidget {
  const AnimatedFavouriteButton(
      {super.key, required this.onPressed, required this.isFilled});

  final Function onPressed;
  final bool isFilled;

  @override
  State<AnimatedFavouriteButton> createState() =>
      _AnimatedFavouriteButtonState();
}

class _AnimatedFavouriteButtonState extends State<AnimatedFavouriteButton>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller.value = controller.upperBound;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 80;
    const double maxHeight = 80;

    return UnconstrainedBox(
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedHeart(
              random1: Random().nextDouble(),
              random2: Random().nextDouble(),
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              controller: controller,
            ),
            AnimatedHeart(
              random1: Random().nextDouble(),
              random2: Random().nextDouble(),
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              controller: controller,
            ),
            AnimatedHeart(
              random1: Random().nextDouble(),
              random2: Random().nextDouble(),
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              controller: controller,
            ),
            IconButton(
              icon: Icon(
                  widget.isFilled ? Icons.favorite : Icons.favorite_outline,
                  color: widget.isFilled ? Colors.red : null),
              onPressed: () {
                controller.reset();
                controller.forward();
                // force a re-render to re-compute random numbers
                setState(() {});
                widget.onPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
