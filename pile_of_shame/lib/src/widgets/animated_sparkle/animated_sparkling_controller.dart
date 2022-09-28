import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pile_of_shame/src/widgets/animated_sparkle/animated_sparkle.dart';

class AnimatedSparklingController extends StatefulWidget {
  const AnimatedSparklingController({super.key});

  @override
  State<AnimatedSparklingController> createState() =>
      _AnimatedSparklingControllerState();
}

class _AnimatedSparklingControllerState
    extends State<AnimatedSparklingController> with TickerProviderStateMixin {
  late AnimationController controller;

  double colorHue = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        // prepare the next animation cycle
        final randomStart = Random().nextInt(300);
        controller.duration = Duration(milliseconds: randomStart + 150);
        setState(() {
          colorHue = Random().nextDouble();
          debugPrint("$colorHue");
        });
      }
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSparkle(
      controller: controller,
      colorHue: colorHue,
    );
  }
}
