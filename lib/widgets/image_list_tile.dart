import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pile_of_shame/utils/constants.dart';

class ImageListTile extends StatelessWidget {
  const ImageListTile({
    super.key,
    required this.imagePath,
    required this.heroTag,
    this.openBuilderOnTap,
    this.title,
    this.subtitle,
  });

  final String imagePath;
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
        openColor: Theme.of(context).colorScheme.background,
        closedBuilder: builder,
        closedColor: Theme.of(context).colorScheme.background,
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
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
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
