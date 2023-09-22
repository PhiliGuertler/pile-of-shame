import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/feedback_container.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';

class DraggableGameDisplaySecondary extends StatelessWidget {
  final GameDisplaySecondary value;
  final Widget child;
  final double width;

  const DraggableGameDisplaySecondary({
    super.key,
    required this.value,
    required this.child,
    this.width = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 32.0,
      child: Draggable<GameDisplaySecondary>(
        data: value,
        feedback: FeedbackContainer(
          child: SizedBox(
            width: width,
            child: child,
          ),
        ),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade700.withOpacity(0.4),
              ),
              BoxShadow(
                color: Theme.of(context).colorScheme.surface,
                blurRadius: 5,
                spreadRadius: -5.0,
                offset: const Offset(1, 3),
              ),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
