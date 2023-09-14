import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class PlayStatusIcon extends StatelessWidget {
  final PlayStatus playStatus;

  const PlayStatusIcon({
    super.key,
    required this.playStatus,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      playStatus.icon,
      color: playStatus.foregroundColor,
    );

    if (playStatus == PlayStatus.playing) {
      const double tilt = 0.05;

      icon = Transform.scale(
          scale: 1.5,
          child: icon
              .animate(
                onPlay: (controller) {
                  controller.repeat();
                },
              )
              .rotate(begin: 0.0, end: tilt * 0.5)
              .then(delay: 200.ms)
              .shakeX(amount: 0.3)
              .then(delay: 200.ms)
              .rotate(begin: 0.0, end: -tilt)
              .then(delay: 200.ms)
              .shakeY(amount: 0.3)
              .then(delay: 400.ms)
              .rotate(begin: 0.0, end: tilt * 0.5));
    }
    if (playStatus == PlayStatus.replaying) {
      icon = Transform.scale(
          scale: 1.5,
          child: icon
              .animate(
                onPlay: (controller) {
                  controller.repeat();
                },
              )
              .shakeX(amount: 0.4, duration: 100.ms)
              .then(delay: 200.ms)
              .shakeY(amount: 0.3, duration: 100.ms)
              .then(delay: 200.ms)
              .shakeY(amount: 0.5)
              .then(delay: 200.ms));
    }
    if (playStatus == PlayStatus.endlessGame) {
      icon = icon
          .animate(
            onPlay: (controller) {
              controller.repeat();
            },
          )
          .rotate(
              begin: 0.0,
              end: 0.5,
              duration: 300.ms,
              curve: Curves.easeInOutBack)
          .then(delay: 1.seconds);
    }
    if (playStatus == PlayStatus.completed ||
        playStatus == PlayStatus.cancelled) {
      icon = icon
          .animate(
            onPlay: (controller) {
              controller.repeat();
            },
          )
          .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.3, 1.3),
              curve: Curves.elasticOut,
              duration: 700.ms)
          .then(delay: Duration(milliseconds: playStatus.index * 100))
          .scale(
              begin: const Offset(1.3, 1.3),
              end: const Offset(1.0, 1.0),
              curve: Curves.elasticIn,
              duration: 700.ms)
          .then(delay: 2.seconds);
    }

    if (playStatus == PlayStatus.completed100Percent) {
      icon = icon
          .animate(
            onPlay: (controller) {
              controller.repeat();
            },
          )
          .scale(
              begin: const Offset(1.3, 1.3),
              end: const Offset(1.0, 1.0),
              curve: Curves.easeIn,
              duration: 400.ms)
          .then(delay: 1.seconds)
          .moveX(
              begin: 0.0, end: 10.0, duration: 200.ms, curve: Curves.easeInBack)
          .fadeOut(duration: 200.ms)
          .swap(
              builder: (context, child) => Icon(
                    PlayStatus.completed.icon,
                    color: PlayStatus.completed.foregroundColor,
                  )
                      .animate()
                      .moveX(
                          begin: -10.0,
                          end: 0.0,
                          duration: 200.ms,
                          curve: Curves.easeOutBack)
                      .fadeIn(duration: 200.ms)
                      .then(delay: 400.ms)
                      .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.3, 1.3),
                          curve: Curves.easeOutBack,
                          duration: 400.ms)
                      .then()
                      .shakeX(duration: 200.ms))
          .then(delay: (200 + 400 + 400 + 50).ms);
    }

    Widget widget = ImageContainer(
      backgroundColor: playStatus.backgroundColor,
      child: icon,
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
