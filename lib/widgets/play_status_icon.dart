import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

class PlayStatusCompleted100PercentIcon extends ConsumerWidget {
  const PlayStatusCompleted100PercentIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(customizeGameDisplaysProvider);

    const completed100 = PlayStatus.completed100Percent;
    const completed = PlayStatus.completed;

    final Widget completed100Icon = Icon(
      completed100.icon,
      color: completed100.foregroundColor,
    );

    Widget icon = completed100Icon;

    settings.maybeWhen(
      data: (settings) {
        if (settings.hasFancyAnimations) {
          final Animate completedIconAnimation = Icon(
            completed.icon,
            color: completed.foregroundColor,
          )
              .animate(
                onPlay: settings.hasRepeatingAnimations
                    ? (controller) {
                        controller.repeat();
                      }
                    : null,
              )
              .moveX(
                begin: -10.0,
                end: 0.0,
                duration: 200.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 200.ms)
              .then(delay: 400.ms)
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.3, 1.3),
                curve: Curves.easeOutBack,
                duration: 400.ms,
              )
              .then()
              .shakeX(duration: 200.ms);

          Animate completed100IconAnimation = completed100Icon.animate().scale(
                begin: const Offset(1.3, 1.3),
                end: const Offset(1.0, 1.0),
                curve: Curves.easeIn,
                duration: 400.ms,
              );

          if (settings.hasRepeatingAnimations) {
            completed100IconAnimation = completed100IconAnimation
                .then(delay: 1.seconds)
                .moveX(
                  begin: 0.0,
                  end: 10.0,
                  duration: 200.ms,
                  curve: Curves.easeInBack,
                )
                .fadeOut(duration: 200.ms);
          }

          icon = completedIconAnimation
              .swap(
                builder: (context, child) => completed100IconAnimation,
              )
              .then(
                delay: (400 + (settings.hasRepeatingAnimations ? 1200 : 0)).ms,
              );
        }
      },
      orElse: () {},
    );

    return icon;
  }
}

class PlayStatusGrowIcon extends ConsumerWidget {
  final PlayStatus playStatus;

  const PlayStatusGrowIcon({
    super.key,
    required this.playStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(customizeGameDisplaysProvider);

    Widget icon = Icon(
      playStatus.icon,
      color: playStatus.foregroundColor,
    );

    settings.maybeWhen(
      data: (settings) {
        if (settings.hasFancyAnimations) {
          icon = icon
              .animate(
                onPlay: settings.hasRepeatingAnimations
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
                duration: 500.ms,
              )
              .then(delay: 500.ms);
        }
      },
      orElse: () {},
    );

    return icon;
  }
}

class PlayStatusRotateIcon extends ConsumerWidget {
  final PlayStatus playStatus;

  const PlayStatusRotateIcon({
    super.key,
    required this.playStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(customizeGameDisplaysProvider);

    Widget icon = Icon(
      playStatus.icon,
      color: playStatus.foregroundColor,
    );

    settings.maybeWhen(
      data: (settings) {
        if (settings.hasFancyAnimations) {
          icon = icon
              .animate(
                onPlay: settings.hasRepeatingAnimations
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
                duration: 500.ms,
              )
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.5, 1.5),
                curve: Curves.easeInOutBack,
                duration: 400.ms,
              )
              .then(delay: 500.ms);
        }
      },
      orElse: () {},
    );

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

class PlayStatusShakeIcon extends ConsumerWidget {
  final PlayStatus playStatus;
  final double maxTilt;
  final List<Shake> shakes;

  const PlayStatusShakeIcon({
    super.key,
    required this.playStatus,
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

  static const Duration shakeDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(customizeGameDisplaysProvider);

    Widget icon = Icon(playStatus.icon, color: playStatus.foregroundColor);

    settings.maybeWhen(
      data: (settings) {
        if (settings.hasFancyAnimations) {
          Animate result = icon.animate(
            onPlay: settings.hasRepeatingAnimations
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
                    duration: shakeDuration * 0.5,
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.1, 1.1),
                    delay: shakeDuration * 0.5,
                    duration: shakeDuration * 0.5,
                  );
            } else {
              result = result.rotate(
                end: maxTilt * shake.tiltAmount * (shake.tiltsRight ? 1 : -1),
                duration: shakeDuration,
              );
            }
            if (i < shakes.length - 1) {
              result = result.then(delay: shakeDuration);
            }
          }

          icon = result;
        }
      },
      orElse: () {},
    );
    return icon;
  }
}

class PlayStatusIcon extends ConsumerWidget {
  final PlayStatus playStatus;

  const PlayStatusIcon({
    super.key,
    required this.playStatus,
  });

  PlayStatusIcon.fromGame({
    super.key,
    required Game game,
  }) : playStatus = game.status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget icon = Icon(
      playStatus.icon,
      color: playStatus.foregroundColor,
    );

    if (playStatus == PlayStatus.playing) {
      icon = PlayStatusShakeIcon(
        playStatus: playStatus,
      );
    }
    if (playStatus == PlayStatus.replaying) {
      icon = PlayStatusShakeIcon(
        playStatus: playStatus,
        shakes: const [
          Shake(),
          Shake(),
          Shake(isShake: false),
          Shake(isShake: false, tiltsRight: false, tiltAmount: 3),
          Shake(),
          Shake(),
          Shake(isShake: false, tiltAmount: 2),
        ],
      );
    }
    if (playStatus == PlayStatus.endlessGame) {
      icon = PlayStatusRotateIcon(
        playStatus: playStatus,
      );
    }

    if (playStatus == PlayStatus.completed ||
        playStatus == PlayStatus.cancelled ||
        playStatus == PlayStatus.onPileOfShame ||
        playStatus == PlayStatus.onWishList) {
      icon = PlayStatusGrowIcon(
        playStatus: playStatus,
      );
    }

    if (playStatus == PlayStatus.completed100Percent) {
      icon = const PlayStatusCompleted100PercentIcon();
    }

    final Widget widget = ImageContainer(
      backgroundColor: playStatus.backgroundColor,
      child: icon,
    );

    return widget;
  }
}
