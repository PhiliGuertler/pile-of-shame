import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:misc_utils/src/utils/constants.dart';
import 'package:transparent_image/transparent_image.dart';

class ParallaxBackground extends StatefulWidget {
  const ParallaxBackground({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  final GlobalKey _backgroundImageKey = GlobalKey();
  double previousScrollFraction = 0.0;

  @override
  Widget build(BuildContext context) {
    ScrollableState? scroll;
    try {
      scroll = Scrollable.of(context);
    } catch (error) {
      scroll = null;
    }

    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: scroll,
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
        parallaxFactor: 0.7,
        updatePreviousScrollFraction: (value) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              previousScrollFraction = value;
            });
          });
        },
        previousScrollFraction: previousScrollFraction,
      ),
      children: [
        FadeInImage(
          key: _backgroundImageKey,
          fadeInDuration: defaultFadeInDuration,
          fadeOutDuration: defaultFadeInDuration,
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage(widget.imagePath),
          fadeInCurve: Curves.easeInOut,
        ).animate().fadeIn(),
      ],
    );
  }
}

class ParallaxImage extends StatelessWidget {
  const ParallaxImage({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 0.9, 1.0],
        ).createShader(bounds);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: ParallaxBackground(imagePath: imagePath),
      ),
    );
  }
}

class ParallaxImageCard extends StatelessWidget {
  const ParallaxImageCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle,
    this.openBuilderOnTap,
  });

  final String imagePath;
  final String title;
  final String? subtitle;

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
      (context, openContainer) => Card(
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: openContainer,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ParallaxImage(imagePath: imagePath),
              ),
              ListTile(
                title: Text(title),
                subtitle: subtitle != null ? Text(subtitle!) : null,
                trailing: openBuilderOnTap != null
                    ? const Icon(Icons.navigate_next)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    this.parallaxFactor = 1.0,
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
    required this.updatePreviousScrollFraction,
    required this.previousScrollFraction,
  }) : super(repaint: scrollable?.position);

  final double parallaxFactor;
  final ScrollableState? scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;
  final void Function(double value) updatePreviousScrollFraction;
  final double previousScrollFraction;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable?.context.findRenderObject() as RenderBox?;
    final listItemBox = listItemContext.findRenderObject()! as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable?.position.viewportDimension;
    double scrollFraction = previousScrollFraction;
    if (viewportDimension != null) {
      scrollFraction = (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);
    }
    updatePreviousScrollFraction(scrollFraction);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(
      0.0,
      ((scrollFraction * 2 - 1) * parallaxFactor).clamp(-1.0, 1.0),
    );

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject()! as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}
