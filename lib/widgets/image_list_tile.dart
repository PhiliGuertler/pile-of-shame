import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/fade_in_image_asset.dart';

class ImageListTile extends StatelessWidget {
  const ImageListTile({
    super.key,
    required this.imageAsset,
    required this.heroTag,
    this.openBuilderOnTap,
    this.title,
    this.subtitle,
  });

  final ImageAssets imageAsset;
  final String heroTag;
  final Widget? title;
  final Widget? subtitle;

  /// Tap handler that triggers a transition to the returned widget of this function.
  final Widget Function(BuildContext, void Function({Object? returnValue}))?
      openBuilderOnTap;

  Widget wrapMe(
    BuildContext context,
    Widget Function(BuildContext context, VoidCallback? openContainer) builder,
  ) {
    late Widget wrapper;
    if (openBuilderOnTap != null) {
      wrapper = OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        openColor: ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          1.0,
        ),
        closedBuilder: builder,
        closedColor: ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          1.0,
        ),
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        openBuilder: openBuilderOnTap!,
      );
    } else {
      wrapper = builder(context, null);
    }
    return wrapper;
  }

  @override
  Widget build(BuildContext context) {
    return wrapMe(
      context,
      (context, openContainer) => ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: InkWell(
          onTap: openContainer,
          child: Card(
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Hero(
                    tag: heroTag,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      ),
                      child: FadeInImageAsset(
                        asset: imageAsset,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: defaultPaddingX - 8.0,
                    ),
                    title: title,
                    subtitle: subtitle,
                    trailing: openBuilderOnTap != null
                        ? const Icon(Icons.navigate_next)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
