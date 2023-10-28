import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class EndDragTargetSlot extends StatelessWidget {
  final GameDisplayLeadingTrailing currentValue;
  final bool isHovered;
  final bool isVisible;

  const EndDragTargetSlot({
    super.key,
    required this.currentValue,
    required this.isHovered,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    bool hasExtraWidth =
        currentValue == GameDisplayLeadingTrailing.lastModifiedOnly;
    hasExtraWidth = hasExtraWidth ||
        currentValue == GameDisplayLeadingTrailing.priceAndLastModified;
    hasExtraWidth =
        hasExtraWidth || currentValue == GameDisplayLeadingTrailing.priceOnly;

    final container = SizedBox(
      width: hasExtraWidth ? textSlotWidth : ImageContainer.imageSize,
      height: ImageContainer.imageSize,
    );

    if (!isVisible) {
      return container;
    }

    return container
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .boxShadow(
          curve: Curves.easeInOut,
          duration: 2.seconds,
          begin: BoxShadow(
            spreadRadius: 5.0,
            color: isHovered
                ? Colors.green.withOpacity(0.7)
                : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
            blurRadius: 5.0,
          ),
          end: BoxShadow(
            spreadRadius: 5.0,
            color: isHovered
                ? Colors.green.withOpacity(0.7)
                : Theme.of(context).colorScheme.surface.withOpacity(0.9),
            blurRadius: 5.0,
          ),
        );
  }
}

class BottomDragTargetSlot extends StatelessWidget {
  final GameDisplaySecondary currentValue;
  final bool isHovered;
  final bool isVisible;

  const BottomDragTargetSlot({
    super.key,
    required this.currentValue,
    required this.isHovered,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    const container = SizedBox(
      height: secondaryHeight,
    );

    if (!isVisible) {
      return container;
    }

    return container
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .boxShadow(
          curve: Curves.easeInOut,
          duration: 2.seconds,
          begin: BoxShadow(
            spreadRadius: 5.0,
            color: isHovered
                ? Colors.green.withOpacity(0.7)
                : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
            blurRadius: 5.0,
          ),
          end: BoxShadow(
            spreadRadius: 5.0,
            color: isHovered
                ? Colors.green.withOpacity(0.7)
                : Theme.of(context).colorScheme.surface.withOpacity(0.9),
            blurRadius: 5.0,
          ),
        );
  }
}

class GameDisplayDragTarget extends ConsumerStatefulWidget {
  final bool isEndPieceMoving;
  final bool isBottomBarMoving;

  const GameDisplayDragTarget({
    super.key,
    this.isEndPieceMoving = false,
    this.isBottomBarMoving = false,
  });

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
            return EndDragTargetSlot(
              currentValue: settings.leading,
              isHovered: isLeadingHovered,
              isVisible: widget.isEndPieceMoving,
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
            return EndDragTargetSlot(
              currentValue: settings.trailing,
              isHovered: isTrailingHovered,
              isVisible: widget.isEndPieceMoving,
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
            return BottomDragTargetSlot(
              currentValue: settings.secondary,
              isHovered: isSecondaryHovered,
              isVisible: widget.isBottomBarMoving,
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
