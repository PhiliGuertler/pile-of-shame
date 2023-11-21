import 'package:flutter/material.dart';

class CustomToolbar extends StatelessWidget {
  static const double overlayRadius = 50.0;

  final List<Widget>? actions;
  final double backgroundOpacity;
  final Widget? title;

  const CustomToolbar({
    super.key,
    this.actions,
    this.backgroundOpacity = 0.8,
    this.title,
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
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.surface;

    return NavigationToolbar(
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
                    child: ColoredBox(
                      color: themeColor.withOpacity(backgroundOpacity),
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
              borderRadius: BorderRadius.circular(overlayRadius),
              child: ColoredBox(
                color: themeColor.withOpacity(backgroundOpacity),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    overflow: TextOverflow.ellipsis,
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
                children: actions!
                    .map(
                      (action) => Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                overlayRadius,
                              ),
                              child: Container(
                                color: themeColor.withOpacity(
                                  backgroundOpacity,
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
    );
  }
}
