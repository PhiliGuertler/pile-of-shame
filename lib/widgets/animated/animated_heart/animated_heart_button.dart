import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'animated_heart.dart';

class AnimatedHeartButton extends StatefulWidget {
  final bool isFilled;
  final VoidCallback onPressed;

  const AnimatedHeartButton(
      {super.key, required this.isFilled, required this.onPressed});

  @override
  State<AnimatedHeartButton> createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<AnimatedHeartButton> {
  late bool shouldDisplayFilledHeart;

  @override
  void initState() {
    super.initState();
    shouldDisplayFilledHeart = widget.isFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedHeart(
          isReverse: widget.isFilled,
          onComplete: () {
            setState(() {
              shouldDisplayFilledHeart = widget.isFilled;
            });
          },
          seed: 123456,
        ),
        AnimatedHeart(
          isReverse: widget.isFilled,
          seed: 42,
        ),
        AnimatedHeart(
          isReverse: widget.isFilled,
          seed: 1337,
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border)
              .animate(target: shouldDisplayFilledHeart ? 1 : 0)
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.3, 1.3),
                curve: Curves.easeInOut,
                duration: 100.ms,
              )
              .fadeOut()
              .swap(
                delay: 100.ms,
                builder: (context, child) {
                  return const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                      .animate()
                      .scale(
                        begin: const Offset(1.5, 1.5),
                        end: const Offset(1.0, 1.0),
                        curve: Curves.easeInOut,
                        duration: 100.ms,
                      )
                      .fadeIn();
                },
              ),
          onPressed: widget.onPressed,
        ),
      ],
    );
  }
}
