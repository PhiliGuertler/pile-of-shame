import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/providers/theming/theme_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

const radius = 50.0;

class SliverFancyImageAppBar extends ConsumerWidget {
  final double stretchTriggerOffset;
  final Future<void> Function()? onStretchTrigger;
  final double height;
  final List<StretchMode> stretchModes;
  final String imagePath;

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
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeSettings = ref.watch(appThemeSettingsProvider);

    final safePadding = MediaQuery.of(context).padding;
    final minHeight = safePadding.top + 50.0;

    return SliverPersistentHeader(
      delegate: _SliverFancyImageAppBarDelegate(
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

class _SliverFancyImageAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final double minHeight;
  final List<StretchMode> stretchModes;
  final String imagePath;
  final Widget? title;
  final List<Widget>? actions;
  final Color? themeColor;

  const _SliverFancyImageAppBarDelegate({
    required this.imagePath,
    required this.height,
    required this.minHeight,
    required this.stretchConfiguration,
    required this.stretchModes,
    required this.title,
    required this.actions,
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

    return FlexibleSpaceBar.createSettings(
      currentExtent: currentExtent,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(defaultBorderRadius * 2),
              bottomRight: Radius.circular(defaultBorderRadius * 2),
            ),
            child: FlexibleSpaceBar(
              stretchModes: stretchModes,
              background: SizedBox(
                height: math.max(height - shrinkOffset, minHeight),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
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
                                borderRadius: BorderRadius.circular(radius),
                                child: Container(
                                  color: themeColor,
                                  child: const BackButton(),
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                  centerMiddle: _getEffectiveCenterTitle(Theme.of(context)),
                  middle: title != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(radius),
                          child: Container(
                            color: themeColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DefaultTextStyle(
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: AppBarTheme.of(context).titleTextStyle ??
                                    Theme.of(context).textTheme.titleLarge ??
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
                                              BorderRadius.circular(radius),
                                          child: Container(color: themeColor),
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
        themeColor != oldDelegate.themeColor;
  }
}
