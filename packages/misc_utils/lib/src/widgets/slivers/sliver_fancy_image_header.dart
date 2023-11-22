import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:misc_utils/src/utils/constants.dart';
import 'package:transparent_image/transparent_image.dart';

class SliverFancyImageHeader extends StatelessWidget {
  final double stretchTriggerOffset;
  final Future<void> Function()? onStretchTrigger;
  final double minHeight;
  final double height;
  final List<StretchMode> stretchModes;
  final String imagePath;

  const SliverFancyImageHeader({
    super.key,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.minHeight = 0.0,
    this.height = 150.0,
    this.stretchModes = const [
      StretchMode.zoomBackground,
    ],
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SliverFancyImageHeaderDelegate(
        imagePath: imagePath,
        height: height,
        minHeight: minHeight,
        stretchConfiguration: OverScrollHeaderStretchConfiguration(
          stretchTriggerOffset: stretchTriggerOffset,
          onStretchTrigger: onStretchTrigger,
        ),
        stretchModes: stretchModes,
      ),
    );
  }
}

class _SliverFancyImageHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double height;
  final List<StretchMode> stretchModes;
  final String imagePath;

  const _SliverFancyImageHeaderDelegate({
    required this.imagePath,
    required this.minHeight,
    required this.height,
    required this.stretchConfiguration,
    required this.stretchModes,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double currentExtent = math.max(height - shrinkOffset, minHeight);
    return FlexibleSpaceBar.createSettings(
      currentExtent: currentExtent,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultBorderRadius * 2.0),
        ),
        child: FlexibleSpaceBar(
          stretchModes: stretchModes,
          background: SizedBox(
            height: math.max(height - shrinkOffset, minHeight),
            child: FadeInImage(
              fadeInDuration: defaultFadeInDuration,
              fadeOutDuration: defaultFadeInDuration,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage(imagePath),
              fadeInCurve: Curves.easeInOut,
            ).animate().fadeIn(),
          ),
        ),
      ),
    );
  }

  @override
  final OverScrollHeaderStretchConfiguration? stretchConfiguration;

  @override
  double get maxExtent => height;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverFancyImageHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        height != oldDelegate.height ||
        imagePath != oldDelegate.imagePath ||
        stretchModes != oldDelegate.stretchModes;
  }
}
