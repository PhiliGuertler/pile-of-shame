import 'dart:math';

import 'package:flutter/material.dart';

import '../../screens/example_animation.dart';

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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          children: [
            HeartAnimation(
              random1: Random().nextDouble(),
              random2: Random().nextDouble(),
              controller: controller,
            ),
            HeartAnimation(
              random1: Random().nextDouble(),
              random2: Random().nextDouble(),
              controller: controller,
            ),
            HeartAnimation(
              random1: Random().nextDouble(),
              random2: Random().nextDouble(),
              controller: controller,
            ),
            Center(
              child: IconButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
