import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:misc_utils/src/utils/constants.dart';
import 'package:transparent_image/transparent_image.dart';

class SlideExpandable extends StatefulWidget {
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
  State<SlideExpandable> createState() => _SlideExpandableState();
}

class _SlideExpandableState extends State<SlideExpandable>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isAnimationForward = true;

  late Animation<double> animation;

  late VoidCallback animationListener;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: 400.ms);

    final Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
    animationListener = () {
      setState(() {});
    };
    animation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(animationListener);
  }

  @override
  void dispose() {
    controller.dispose();
    animation.removeListener(animationListener);
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
                                  horizontal: 16.0,
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
                              )
                                  .animate(target: isAnimationForward ? 0 : 1)
                                  .fadeIn(delay: 200.ms),
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
                            )
                                .animate(target: isAnimationForward ? 0 : 1)
                                .fadeIn(delay: 100.ms),
                          ],
                        ),
                        SizedBox(
                          width: (animation.value * 80) +
                              ((1 - animation.value) * constraints.maxWidth),
                          height: 80,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              topLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(30.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: FadeInImage(
                              fadeInDuration: defaultFadeInDuration,
                              fadeOutDuration: defaultFadeInDuration,
                              width: double.infinity,
                              height: 80.0,
                              fit: BoxFit.cover,
                              placeholder: MemoryImage(kTransparentImage),
                              image: AssetImage(widget.imagePath),
                              fadeInCurve: Curves.easeInOut,
                            ).animate().fadeIn(),
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
