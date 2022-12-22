import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/widgets/animated_sparkle/animated_sparkle.dart';

import 'random_star.dart';

class AnimatedSparklingController extends StatefulWidget {
  const AnimatedSparklingController(
      {super.key, this.child, this.numSparks = 5});

  final Widget? child;
  final int numSparks;

  @override
  State<AnimatedSparklingController> createState() =>
      _AnimatedSparklingControllerState();
}

class _AnimatedSparklingControllerState
    extends State<AnimatedSparklingController> with TickerProviderStateMixin {
  late AnimationController controller;

  List<RandomStar> stars = [];

  GlobalKey childKey = GlobalKey();

  Size getChildSize() {
    final BuildContext? keyContext = childKey.currentContext;
    Size childSize = const Size(1, 1);
    if (keyContext != null) {
      final RenderBox box = keyContext.findRenderObject() as RenderBox;
      childSize = box.size;
    }
    return childSize;
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // prepare the next animation cycle
        final randomStart = Random().nextInt(200);
        controller.duration = Duration(milliseconds: randomStart + 900);

        Size childSize = getChildSize();
        setState(() {
          stars.clear();
          for (int i = 0; i < widget.numSparks; ++i) {
            stars.add(RandomStar(controller,
                maxWidth: childSize.width,
                maxHeight: childSize.height,
                startOffset: i / widget.numSparks,
                endOffset: (i + 1) / widget.numSparks));
          }
          controller.reset();
          controller.forward();
        });
      }
    });
    Size childSize = getChildSize();
    for (int i = 0; i < widget.numSparks; ++i) {
      stars.add(
        RandomStar(
          controller,
          maxWidth: childSize.width,
          maxHeight: childSize.height,
        ),
      );
    }
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Stack(
          children: [
            if (widget.child != null)
              Container(key: childKey, child: widget.child!),
            ...stars.map<Widget>(
              (e) => AnimatedSparkle(
                star: e,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
