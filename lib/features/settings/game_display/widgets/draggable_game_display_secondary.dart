import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/feedback_container.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/utils/constants.dart';

class DraggableGameDisplaySecondary extends StatelessWidget {
  static const double width = 165.0;

  final GameDisplaySecondary value;
  final Widget child;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnded;

  const DraggableGameDisplaySecondary({
    super.key,
    required this.value,
    required this.child,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: secondaryHeight,
      child: Draggable<GameDisplaySecondary>(
        data: value,
        onDragStarted: onDragStarted,
        onDragEnd: (details) {
          onDragEnded();
        },
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
