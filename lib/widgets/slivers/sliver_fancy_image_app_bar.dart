import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/providers/theming/theme_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

const overlayRadius = 50.0;

const minimumScrollTriggerOffset = 8.0;

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
      clockwise: true,
    )
    ..lineTo(size.width - borderRadius, size.height - borderRadius)
    ..arcToPoint(
      Offset(size.width, size.height),
      radius: Radius.circular(borderRadius),
      clockwise: true,
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
    this.height = 250.0,
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
    final appThemeSettings = ref.watch(appThemeSettingsProvider);

    final safePadding = MediaQuery.of(context).padding;
    final minHeight = safePadding.top +
        overlayRadius +
        -math.min(borderRadius, 0) +
        minimumScrollTriggerOffset;

    return SliverPersistentHeader(
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
        themeColor: appThemeSettings.when(
          data: (data) => data.primaryColor.withOpacity(0.5),
          error: (error, stackTrace) => null,
          loading: () => null,
        ),
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
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final safePadding = MediaQuery.of(context).padding;

    double currentExtent = math.max(height - shrinkOffset, minHeight);
    double currentOpacity =
        math.max(0.0, 0.8 - (shrinkOffset / minHeight).clamp(0.0, 0.8));

    return FlexibleSpaceBar.createSettings(
      currentExtent: currentExtent,
      child: ClipDecider(
        borderRadius: borderRadius,
        child: FlexibleSpaceBar(
          stretchModes: stretchModes,
          background: SizedBox(
            height: currentExtent,
            child: Stack(
              children: [
                Opacity(
                  opacity: currentOpacity,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: safePadding.top),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 50.0,
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
                                      borderRadius:
                                          BorderRadius.circular(overlayRadius),
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
                                      softWrap: true,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: actions!
                                      .map(
                                        (action) => Stack(
                                          children: [
                                            Positioned.fill(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        overlayRadius),
                                                child: Container(
                                                  color:
                                                      themeColor?.withOpacity(
                                                          currentOpacity),
                                                ),
                                              ),
                                            ),
                                            action
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
