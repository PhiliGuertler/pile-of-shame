import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class PlayStatusCompleted100PercentIcon extends StatelessWidget {
  final bool hasAnimation;
  final bool hasRepeatingAnimation;

  const PlayStatusCompleted100PercentIcon({
    super.key,
    this.hasAnimation = true,
    this.hasRepeatingAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    const completed100 = PlayStatus.completed100Percent;
    const completed = PlayStatus.completed;

    Widget completed100Icon = Icon(
      completed100.icon,
      color: completed100.foregroundColor,
    );

    Widget icon = completed100Icon;

    if (hasAnimation) {
      Animate completedIconAnimation = Icon(
        completed.icon,
        color: completed.foregroundColor,
      )
          .animate(
            onPlay: hasRepeatingAnimation
                ? (controller) {
                    controller.repeat();
                  }
                : null,
          )
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
          .shakeX(duration: 200.ms);

      Animate completed100IconAnimation = completed100Icon.animate().scale(
          begin: const Offset(1.3, 1.3),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeIn,
          duration: 400.ms);

      if (hasRepeatingAnimation) {
        completed100IconAnimation = completed100IconAnimation
            .then(delay: 1.seconds)
            .moveX(
                begin: 0.0,
                end: 10.0,
                duration: 200.ms,
                curve: Curves.easeInBack)
            .fadeOut(duration: 200.ms);
      }

      icon = completedIconAnimation
          .swap(
            builder: (context, child) => completed100IconAnimation,
          )
          .then(delay: (400 + (hasRepeatingAnimation ? 1200 : 0)).ms);
    }

    return icon;
  }
}

class PlayStatusGrowIcon extends StatelessWidget {
  final bool hasAnimation;
  final bool hasRepeatingAnimation;
  final PlayStatus playStatus;

  const PlayStatusGrowIcon({
    super.key,
    required this.playStatus,
    this.hasAnimation = true,
    this.hasRepeatingAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      playStatus.icon,
      color: playStatus.foregroundColor,
    );

    if (hasAnimation) {
      icon = icon
          .animate(
            onPlay: hasRepeatingAnimation
                ? (controller) {
                    controller.repeat(reverse: true);
                  }
                : null,
          )
          .then(delay: 300.ms)
          .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.5, 1.5),
              curve: Curves.easeOutBack,
              duration: 500.ms)
          .then(delay: 500.ms);
    }

    return icon;
  }
}

class PlayStatusRotateIcon extends StatelessWidget {
  final bool hasAnimation;
  final bool hasRepeatingAnimation;
  final PlayStatus playStatus;

  const PlayStatusRotateIcon({
    super.key,
    required this.playStatus,
    this.hasAnimation = true,
    this.hasRepeatingAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      playStatus.icon,
      color: playStatus.foregroundColor,
    );

    if (hasAnimation) {
      icon = icon
          .animate(
            onPlay: hasRepeatingAnimation
                ? (controller) {
                    controller.repeat(reverse: true);
                  }
                : null,
          )
          .then(delay: 500.ms)
          .rotate(
              begin: -0.5,
              end: 0,
              curve: Curves.easeInOutBack,
              duration: 500.ms)
          .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.5, 1.5),
              curve: Curves.easeInOutBack,
              duration: 400.ms)
          .then(delay: 500.ms);
    }

    return icon;
  }
}

class Shake {
  final bool isShake;
  final bool isHorizontal;
  final bool tiltsRight;
  final int tiltAmount;

  const Shake({
    this.isShake = true,
    this.isHorizontal = false,
    this.tiltsRight = true,
    this.tiltAmount = 1,
  });
}

class PlayStatusShakeIcon extends StatelessWidget {
  final bool hasAnimation;
  final bool hasRepeatingAnimation;
  final PlayStatus playStatus;
  final double maxTilt;
  final List<Shake> shakes;

  const PlayStatusShakeIcon({
    super.key,
    required this.playStatus,
    this.hasAnimation = true,
    this.hasRepeatingAnimation = true,
    this.maxTilt = 0.05,
    this.shakes = const [
      Shake(isShake: false),
      Shake(),
      Shake(isHorizontal: true),
      Shake(isShake: false, tiltsRight: false, tiltAmount: 2),
      Shake(isHorizontal: true),
      Shake(isShake: false),
    ],
  });

  final Duration shakeDuration = const Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(playStatus.icon, color: playStatus.foregroundColor);

    if (hasAnimation) {
      Animate result = icon.animate(
        onPlay: hasRepeatingAnimation
            ? (controller) {
                controller.repeat(reverse: true);
              }
            : null,
      );

      for (int i = 0; i < shakes.length; ++i) {
        final shake = shakes[i];
        if (shake.isShake) {
          if (shake.isHorizontal) {
            result = result.shakeX(amount: 0.8, duration: shakeDuration);
          } else {
            result = result.shakeY(amount: 0.8, duration: shakeDuration);
          }
          result = result
              .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1.0, 1.0),
                  duration: shakeDuration * 0.5)
              .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.1, 1.1),
                  delay: shakeDuration * 0.5,
                  duration: shakeDuration * 0.5);
        } else {
          result = result.rotate(
              end: maxTilt * shake.tiltAmount * (shake.tiltsRight ? 1 : -1),
              duration: shakeDuration);
        }
        if (i < shakes.length - 1) {
          result = result.then(delay: shakeDuration);
        }
      }

      icon = result;
    }

    return icon;
  }
}

class PlayStatusIcon extends StatelessWidget {
  final PlayStatus playStatus;
  final bool hasAnimation;
  final bool hasRepeatingAnimation;

  const PlayStatusIcon({
    super.key,
    required this.playStatus,
    this.hasAnimation = true,
    this.hasRepeatingAnimation = true,
  });

  PlayStatusIcon.fromGame({
    super.key,
    required Game game,
    this.hasAnimation = true,
    this.hasRepeatingAnimation = true,
  }) : playStatus = game.status;

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      playStatus.icon,
      color: playStatus.foregroundColor,
    );

    if (playStatus == PlayStatus.playing) {
      icon = PlayStatusShakeIcon(
        playStatus: playStatus,
        hasAnimation: hasAnimation,
        hasRepeatingAnimation: hasRepeatingAnimation,
      );
    }
    if (playStatus == PlayStatus.replaying) {
      icon = PlayStatusShakeIcon(
        playStatus: playStatus,
        hasAnimation: hasAnimation,
        hasRepeatingAnimation: hasRepeatingAnimation,
        shakes: const [
          Shake(isHorizontal: false),
          Shake(),
          Shake(isShake: false),
          Shake(isShake: false, tiltsRight: false, tiltAmount: 3),
          Shake(),
          Shake(isHorizontal: false),
          Shake(isShake: false, tiltAmount: 2),
        ],
      );
    }
    if (playStatus == PlayStatus.endlessGame) {
      icon = PlayStatusRotateIcon(
        playStatus: playStatus,
        hasAnimation: hasAnimation,
        hasRepeatingAnimation: hasRepeatingAnimation,
      );
    }

    if (playStatus == PlayStatus.completed ||
        playStatus == PlayStatus.cancelled) {
      icon = PlayStatusGrowIcon(
        playStatus: playStatus,
        hasAnimation: hasAnimation,
        hasRepeatingAnimation: hasRepeatingAnimation,
      );
    }

    if (playStatus == PlayStatus.completed100Percent) {
      icon = PlayStatusCompleted100PercentIcon(
        hasAnimation: hasAnimation,
        hasRepeatingAnimation: hasRepeatingAnimation,
      );
    }

    Widget widget = ImageContainer(
      backgroundColor: playStatus.backgroundColor,
      child: icon,
    );

    if (playStatus.isCompleted && hasAnimation) {
      widget = widget
          .animate(
            onPlay: hasRepeatingAnimation
                ? (controller) => controller.repeat()
                : null,
          )
          .shimmer(duration: 1.seconds, delay: 2.seconds);
    }

    return widget;
  }
}
