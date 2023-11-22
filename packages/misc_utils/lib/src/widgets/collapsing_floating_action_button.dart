import 'package:flutter/material.dart';

class CollapsingFloatingActionButton extends StatelessWidget {
  final Duration animationDuration;
  final VoidCallback onPressed;
  final bool isExtended;
  final Icon icon;
  final Widget label;

  const CollapsingFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.isExtended,
    required this.icon,
    required this.label,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: animationDuration,
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        label: AnimatedSwitcher(
          duration: animationDuration,
          transitionBuilder: (child, animation) {
            final fancyAnimation =
                animation.drive(CurveTween(curve: Curves.easeInOutBack));

            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: fancyAnimation,
                axis: Axis.horizontal,
                child: child,
              ),
            );
          },
          child: !isExtended
              ? icon
              : Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: icon,
                    ),
                    label,
                  ],
                ),
        ),
      ),
    );
  }
}
