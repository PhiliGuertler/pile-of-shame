import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:transparent_image/transparent_image.dart';

const overlayRadius = 50.0;

const minimumToolbarHeight = 50.0;

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

class SliverFancyImageAppBar extends ConsumerWidget {
  final double stretchTriggerOffset;
  final Future<void> Function()? onStretchTrigger;
  final double height;
  final List<StretchMode> stretchModes;
  final String imagePath;
  final double borderRadius;

  final Widget? title;
  final List<Widget>? actions;

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
    this.borderRadius = defaultBorderRadius * 2.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safePadding = MediaQuery.of(context).padding;
    final minHeight = safePadding.top + minimumToolbarHeight;

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
        themeColor: Theme.of(context).colorScheme.primaryContainer,
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
  final Color? themeColor;

  const _SliverFancyImageAppBarDelegate({
    required this.imagePath,
    required this.height,
    required this.minHeight,
    required this.stretchConfiguration,
    required this.stretchModes,
    required this.title,
    required this.actions,
    required this.borderRadius,
    this.themeColor,
  });

  bool _getEffectiveCenterTitle(ThemeData theme) {
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return actions == null || actions!.length < 2;
    }
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final safePadding = MediaQuery.of(context).padding;

    final double currentExtent = math.max(height - shrinkOffset, minHeight);
    final double currentOpacity = math.max(
      0.0,
      0.8 - (shrinkOffset / (height - minimumToolbarHeight)).clamp(0.0, 0.8),
    );
    final double currentBackgroundBlend = 1.0 -
        math.max(
          0.0,
          1.0 -
              (shrinkOffset / (height - minimumToolbarHeight)).clamp(0.0, 1.0),
        );

    return FlexibleSpaceBar.createSettings(
      currentExtent: currentExtent,
      child: ClipDecider(
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
                    fadeInDuration: 200.ms,
                    fadeOutDuration: 200.ms,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: AssetImage(imagePath),
                  ).animate(delay: 200.ms).fadeIn(),
                ),
                Material(
                  color: themeColor?.withOpacity(currentBackgroundBlend),
                  elevation: currentBackgroundBlend * 4.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: safePadding.top),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: minimumToolbarHeight,
                        child: NavigationToolbar(
                          middleSpacing: AppBarTheme.of(context).titleSpacing ??
                              NavigationToolbar.kMiddleSpacing,
                          leading: Navigator.of(context).canPop()
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          overlayRadius,
                                        ),
                                        child: Container(
                                          color: themeColor
                                              ?.withOpacity(currentOpacity),
                                          child: const BackButton(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                          centerMiddle:
                              _getEffectiveCenterTitle(Theme.of(context)),
                          middle: title != null
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(overlayRadius),
                                  child: Container(
                                    color:
                                        themeColor?.withOpacity(currentOpacity),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DefaultTextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        style: AppBarTheme.of(context)
                                                .titleTextStyle ??
                                            Theme.of(context)
                                                .textTheme
                                                .titleLarge ??
                                            const TextStyle(),
                                        child: title!,
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                          trailing: actions != null
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: actions!
                                        .map(
                                          (action) => Stack(
                                            children: [
                                              Positioned.fill(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    overlayRadius,
                                                  ),
                                                  child: Container(
                                                    color:
                                                        themeColor?.withOpacity(
                                                      currentOpacity,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              action,
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                              : null,
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
