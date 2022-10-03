import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GameCoverView extends StatelessWidget {
  const GameCoverView({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          if (imageUrl != null)
            Positioned.fill(
              child: Image(
                image: CachedNetworkImageProvider(imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.white.withOpacity(0.02),
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.05),
                ],
                stops: const [
                  0,
                  0.6,
                  1,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
