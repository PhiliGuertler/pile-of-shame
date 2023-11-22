import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:misc_utils/src/utils/constants.dart';
import 'package:misc_utils/src/widgets/custom_toolbar.dart';
import 'package:transparent_image/transparent_image.dart';

// Creates a drawer-like gap at the bottom of the clipped area
class InvertedCornerClipPath extends CustomClipper<Path> {
  final double borderRadius;
  const InvertedCornerClipPath({required this.borderRadius});

  @override
  Path getClip(Size size) => Path()
    ..lineTo(0, 0)
    ..lineTo(0, size.height)
    ..arcToPoint(
      Offset(
        borderRadius,
        size.height - borderRadius,
      ),
      radius: Radius.circular(borderRadius),
    )
    ..lineTo(size.width - borderRadius, size.height - borderRadius)
    ..arcToPoint(
      Offset(size.width, size.height),
      radius: Radius.circular(borderRadius),
    )
    ..lineTo(size.width, 0);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class SliverFancyImageAppBar extends StatelessWidget {
  final double stretchTriggerOffset;
  final Future<void> Function()? onStretchTrigger;
  final double height;
  final List<StretchMode> stretchModes;
  final String imagePath;

  /// radius of the corners.
  /// negative values will display an inset at the bottom like the top of a drawer
  final double borderRadius;

  final Widget? title;
  final List<Widget>? actions;
  final Widget? bottom;

  const SliverFancyImageAppBar({
    super.key,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.height = 300.0,
    this.stretchModes = const [
      StretchMode.zoomBackground,
    ],
    required this.imagePath,
    this.title,
    this.actions,
    this.borderRadius = -48.0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding;
    final minHeight = safePadding.top +
        minimumToolbarHeight +
        (bottom != null ? minimumToolbarHeight : 0);

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverFancyImageAppBarDelegate(
        borderRadius: borderRadius,
        imagePath: imagePath,
        height: height,
        minHeight: minHeight,
        stretchConfiguration: OverScrollHeaderStretchConfiguration(
          stretchTriggerOffset: stretchTriggerOffset,
          onStretchTrigger: onStretchTrigger,
        ),
        stretchModes: stretchModes,
        title: title,
        actions: actions,
        themeColor: Theme.of(context).colorScheme.surface,
        tintColor: Theme.of(context).colorScheme.surfaceTint,
        bottom: bottom,
      ),
    );
  }
}

class ClipDecider extends StatelessWidget {
  final double borderRadius;
  final Widget child;

  const ClipDecider({
    super.key,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (borderRadius < 0) {
      return ClipPath(
        clipper: InvertedCornerClipPath(
          borderRadius: borderRadius.abs(),
        ),
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius.abs(),
      ),
      child: child,
    );
  }
}

class _SliverFancyImageAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final double minHeight;
  final List<StretchMode> stretchModes;
  final String imagePath;
  final Widget? title;
  final List<Widget>? actions;
  final double borderRadius;
  final Color themeColor;
  final Color tintColor;
  final Widget? bottom;

  const _SliverFancyImageAppBarDelegate({
    required this.imagePath,
    required this.height,
    required this.minHeight,
    required this.stretchConfiguration,
    required this.stretchModes,
    required this.title,
    required this.actions,
    required this.borderRadius,
    required this.themeColor,
    required this.tintColor,
    this.bottom,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final safePadding = MediaQuery.of(context).padding;

    final double effectiveToolbarHeight =
        minimumToolbarHeight * (bottom != null ? 2 : 1);

    final double currentExtent = math.max(height - shrinkOffset, minHeight);
    final double currentOpacity = math.max(
      0.0,
      0.8 - (shrinkOffset / (height - effectiveToolbarHeight)).clamp(0.0, 0.8),
    );
    final double currentBackgroundBlend = 1.0 -
        math.max(
          0.0,
          1.0 -
              (shrinkOffset / (height - effectiveToolbarHeight))
                  .clamp(0.0, 1.0),
        );

    return FlexibleSpaceBar.createSettings(
      currentExtent: currentExtent,
      child: Stack(
        children: [
          if (bottom == null && borderRadius < 0)
            Opacity(
              opacity: currentOpacity,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: (borderRadius.abs() * 0.5 - 1) *
                      (1.0 - currentBackgroundBlend),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    height: 2.0,
                    width: 60.0,
                  ),
                ),
              ),
            ),
          ClipDecider(
            borderRadius: borderRadius * (1.0 - currentBackgroundBlend),
            child: FlexibleSpaceBar(
              stretchModes: stretchModes,
              background: SizedBox(
                height: currentExtent,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: currentOpacity,
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
                    Material(
                      color: ElevationOverlay.applySurfaceTint(
                        themeColor,
                        tintColor,
                        currentBackgroundBlend * 4.0,
                      ).withOpacity(
                        math.pow(currentBackgroundBlend, 5.0).toDouble(),
                      ),
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.only(top: safePadding.top),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: minimumToolbarHeight,
                            child: CustomToolbar(
                              title: title,
                              backgroundOpacity: currentOpacity,
                              actions: actions,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (bottom != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: minimumToolbarHeight,
                child: bottom,
              ),
            ),
        ],
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
  bool shouldRebuild(covariant _SliverFancyImageAppBarDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        height != oldDelegate.height ||
        themeColor != oldDelegate.themeColor ||
        imagePath != oldDelegate.imagePath ||
        title != oldDelegate.title ||
        actions != oldDelegate.actions ||
        borderRadius != oldDelegate.borderRadius;
  }
}
