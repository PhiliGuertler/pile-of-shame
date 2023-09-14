import 'package:flutter/material.dart';
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
    return ImageContainer(
      backgroundColor: playStatus.backgroundColor,
      child: Icon(
        playStatus.icon,
        color: playStatus.foregroundColor,
      ),
    );
  }
}
