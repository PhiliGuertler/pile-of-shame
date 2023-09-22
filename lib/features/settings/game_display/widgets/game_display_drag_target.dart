import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/draggable_game_display_secondary.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class GameDisplayDragTarget extends ConsumerStatefulWidget {
  final bool isEndPieceMoving;
  final bool isBottomBarMoving;

  const GameDisplayDragTarget(
      {super.key,
      this.isEndPieceMoving = false,
      this.isBottomBarMoving = false});

  @override
  ConsumerState<GameDisplayDragTarget> createState() =>
      _GameDisplayDragTargetState();
}

class _GameDisplayDragTargetState extends ConsumerState<GameDisplayDragTarget> {
  bool isTrailingHovered = false;
  bool isLeadingHovered = false;
  bool isSecondaryHovered = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(customizeGameDisplaysProvider);

    return settings.maybeWhen(
      data: (settings) => ListTile(
        title: const Text(
          "Title",
          style: TextStyle(color: Colors.transparent),
        ),
        leading: DragTarget<GameDisplayLeadingTrailing>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: ImageContainer.imageSize,
              height: ImageContainer.imageSize,
              decoration: isLeadingHovered || widget.isEndPieceMoving
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: isLeadingHovered
                              ? Colors.grey.shade700.withOpacity(0.4)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                        ),
                        const BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 5,
                          spreadRadius: -5.0,
                        ),
                      ],
                    )
                  : null,
            );
          },
          onAccept: (data) {
            ref
                .read(customizeGameDisplaysProvider.notifier)
                .setCustomGameDisplay(
                  settings.copyWith(leading: data),
                );
            setState(() {
              isLeadingHovered = false;
            });
          },
          onMove: (details) {
            setState(() {
              isLeadingHovered = true;
            });
          },
          onLeave: (details) {
            setState(() {
              isLeadingHovered = false;
            });
          },
        ),
        trailing: DragTarget<GameDisplayLeadingTrailing>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: ImageContainer.imageSize,
              height: ImageContainer.imageSize,
              decoration: isTrailingHovered || widget.isEndPieceMoving
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: isTrailingHovered
                              ? Colors.grey.shade700.withOpacity(0.4)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                        ),
                        const BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 5,
                          spreadRadius: -5.0,
                        ),
                      ],
                    )
                  : null,
            );
          },
          onAccept: (data) {
            ref
                .read(customizeGameDisplaysProvider.notifier)
                .setCustomGameDisplay(
                  settings.copyWith(trailing: data),
                );
            setState(() {
              isTrailingHovered = false;
            });
          },
          onMove: (details) {
            setState(() {
              isTrailingHovered = true;
            });
          },
          onLeave: (details) {
            setState(() {
              isTrailingHovered = false;
            });
          },
        ),
        subtitle: DragTarget<GameDisplaySecondary>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: DraggableGameDisplaySecondary.width,
              height: 32.0,
              decoration: isSecondaryHovered || widget.isBottomBarMoving
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: isSecondaryHovered
                              ? Colors.grey.shade700.withOpacity(0.4)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                        ),
                        const BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 5,
                          spreadRadius: -5.0,
                        ),
                      ],
                    )
                  : null,
            );
          },
          onAccept: (data) {
            ref
                .read(customizeGameDisplaysProvider.notifier)
                .setCustomGameDisplay(
                  settings.copyWith(secondary: data),
                );
            setState(() {
              isSecondaryHovered = false;
            });
          },
          onMove: (details) {
            setState(() {
              isSecondaryHovered = true;
            });
          },
          onLeave: (details) {
            setState(() {
              isSecondaryHovered = false;
            });
          },
        ),
      ),
      orElse: () => const SizedBox(),
    );
  }
}
