import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/models/play_status.dart';

class PlayStatusDisplay extends StatelessWidget {
  final PlayStatus playStatus;

  const PlayStatusDisplay({super.key, required this.playStatus});

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      decoration: BoxDecoration(
        color: playStatus.toBackgroundColor(context),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Center(
          child: Text(
            playStatus.toLocaleString(context),
            style: TextStyle(
              color: playStatus.toForegroundColor(context),
            ),
          ),
        ),
      ),
    );

    if (playStatus.isCompleted) {
      widget = widget.animate(
        onPlay: (controller) {
          controller.repeat();
        },
      ).shimmer(duration: 1.seconds, delay: 2.seconds);
    }

    return widget;
  }
}