import 'package:flutter/material.dart';

/// Implements a MaterialPageRoute but the screen instead slides in from the bottom
class MaterialPageSlideRoute<T> extends PageRoute<T> {
  final MaterialPageRoute<T> _materialPageRoute;

  final Widget Function(BuildContext) builder;

  MaterialPageSlideRoute({required this.builder, super.settings})
      : _materialPageRoute = MaterialPageRoute(builder: builder);

  @override
  Color? get barrierColor => _materialPageRoute.barrierColor;

  @override
  String? get barrierLabel => _materialPageRoute.barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final curve = CurveTween(curve: Curves.easeOutCubic);
    final offsetAnimation = animation.drive(tween.chain(curve));

    return SlideTransition(
      position: offsetAnimation,
      child: builder(context),
    );
  }

  @override
  bool get maintainState => _materialPageRoute.maintainState;

  @override
  Duration get transitionDuration => _materialPageRoute.transitionDuration;
}
