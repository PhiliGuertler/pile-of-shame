import 'package:flutter/material.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/feedback_container.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';

class DraggableGameDisplayLeadingTrailing extends StatelessWidget {
  final GameDisplayLeadingTrailing value;
  final Widget child;
  final double width;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnded;

  const DraggableGameDisplayLeadingTrailing({
    super.key,
    required this.value,
    required this.child,
    this.width = ImageContainer.imageSize,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: ImageContainer.imageSize,
      child: Draggable<GameDisplayLeadingTrailing>(
        data: value,
        onDragStarted: onDragStarted,
        onDragEnd: (details) {
          onDragEnded();
        },
        feedback: FeedbackContainer(
          child: SizedBox(
            width: width,
            height: ImageContainer.imageSize,
            child: child,
          ),
        ),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade700.withValues(alpha: 0.4),
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
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
