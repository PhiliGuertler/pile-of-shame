import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/utils/constants.dart';

class SlideExpandable extends ConsumerStatefulWidget {
  final String imagePath;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final List<Widget> children;

  const SlideExpandable({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.children = const [],
  });

  @override
  ConsumerState<SlideExpandable> createState() => _SlideExpandableState();
}

class _SlideExpandableState extends ConsumerState<SlideExpandable>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isAnimationForward = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: 400.ms);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Animate> childWidgets = widget.children
        .map(
          (child) => AnimatedSize(
            curve: Curves.easeInOutBack,
            duration: 400.ms,
            child: isAnimationForward
                ? const SizedBox(
                    height: 0,
                  )
                : child,
          ).animate().fadeIn(duration: 400.ms),
        )
        .toList();
    for (int i = childWidgets.length - 1; i > 0; --i) {
      childWidgets.insert(
        i,
        AnimatedSize(
          curve: Curves.easeInOutBack,
          duration: 400.ms,
          child: isAnimationForward
              ? const SizedBox(height: 0)
              : const Divider(
                  height: 1,
                ),
        ).animate().fadeIn(duration: 400.ms),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          topLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(30.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(12.0),
            ),
            child: GestureDetector(
              onTap: () {
                if (isAnimationForward) {
                  controller.forward(from: controller.value);
                } else {
                  controller.reverse(from: controller.value);
                }
                setState(() {
                  isAnimationForward = !isAnimationForward;
                });
              },
              child: ColoredBox(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final Animation<double> curve = CurvedAnimation(
                      parent: controller,
                      curve: Curves.fastEaseInToSlowEaseOut,
                    );
                    final animation =
                        Tween<double>(begin: constraints.maxWidth, end: 80)
                            .animate(curve)
                          ..addListener(() {
                            setState(() {
                              // The state that has changed here is the animation object's value.
                            });
                          });

                    return Stack(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              height: 80,
                              width: 80,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPaddingX - 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DefaultTextStyle(
                                      style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall ??
                                          const TextStyle(),
                                      child: widget.title,
                                    ),
                                    DefaultTextStyle(
                                      style: Theme.of(context)
                                              .textTheme
                                              .labelMedium ??
                                          const TextStyle(),
                                      child: widget.subtitle,
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(delay: 200.ms),
                            ),
                            IntrinsicWidth(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: DefaultTextStyle(
                                  style:
                                      Theme.of(context).textTheme.bodyLarge ??
                                          const TextStyle(),
                                  child: widget.trailing,
                                ),
                              ),
                            ).animate().fadeIn(delay: 100.ms),
                          ],
                        ),
                        SizedBox(
                          width: animation.value,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              topLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(30.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: Image.asset(
                              widget.imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 80,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),
          ),
          ...childWidgets,
        ],
      ),
    );
  }
}