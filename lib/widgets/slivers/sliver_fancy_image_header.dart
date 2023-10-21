import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/fade_in_image_asset.dart';

class SliverFancyImageHeader extends StatelessWidget {
  final double stretchTriggerOffset;
  final Future<void> Function()? onStretchTrigger;
  final double minHeight;
  final double height;
  final List<StretchMode> stretchModes;
  final ImageAssets imageAsset;

  const SliverFancyImageHeader({
    super.key,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.minHeight = 0.0,
    this.height = 150.0,
    this.stretchModes = const [
      StretchMode.zoomBackground,
    ],
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SliverFancyImageHeaderDelegate(
        imageAssets: imageAsset,
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
  final ImageAssets imageAssets;

  const _SliverFancyImageHeaderDelegate({
    required this.imageAssets,
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
            child: FadeInImageAsset(
              asset: imageAssets,
              width: double.infinity,
              height: double.infinity,
            ),
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
    return minHeight != oldDelegate.minHeight || height != oldDelegate.height;
  }
}
