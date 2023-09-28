import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/play_status.dart';

class PlayStatusDisplay extends StatelessWidget {
  static const double height = 32.0;

  final PlayStatus playStatus;

  const PlayStatusDisplay({super.key, required this.playStatus});

  PlayStatusDisplay.fromGame({super.key, required Game game})
      : playStatus = game.status;

  @override
  Widget build(BuildContext context) {
    final Widget widget = Container(
      height: height,
      decoration: BoxDecoration(
        color: playStatus.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Center(
          child: Text(
            playStatus.toLocaleString(AppLocalizations.of(context)!),
            style: TextStyle(
              color: playStatus.foregroundColor,
            ),
          ),
        ),
      ),
    );

    return widget;
  }
}
