import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  static const mobileBreakpointWidth = 800.0;

  // Scaffold fields
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final NavigationRail? navigationRail;
  final Widget? bottomSheet;
  final Widget? drawer;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final Color? drawerScrimColor;
  final Widget? endDrawer;
  final bool endDrawerEnableOpenDragGesture;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final void Function(bool)? onDrawerChanged;
  final void Function(bool)? onEndDrawerChanged;
  final AlignmentDirectional persistentFooterAlignment;
  final List<Widget>? persistentFooterButtons;
  final bool primary;
  final bool? resizeToAvoidBottomInset;
  final String? restorationId;
  final Widget? body;

  // Custom fields
  final bool isLoginRequired;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.navigationRail,
    this.bottomSheet,
    this.drawer,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.drawerScrimColor,
    this.endDrawer,
    this.endDrawerEnableOpenDragGesture = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.persistentFooterButtons,
    this.primary = true,
    this.resizeToAvoidBottomInset,
    this.restorationId,
    this.body,
    this.isLoginRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final scaffold = Scaffold(
      key: key,
      appBar: appBar,
      backgroundColor: backgroundColor,
      bottomNavigationBar:
          (width <= mobileBreakpointWidth || navigationRail == null)
              ? bottomNavigationBar
              : null,
      bottomSheet: bottomSheet,
      drawer: drawer,
      drawerDragStartBehavior: drawerDragStartBehavior,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      drawerScrimColor: drawerScrimColor,
      endDrawer: endDrawer,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      floatingActionButtonLocation: floatingActionButtonLocation,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
      persistentFooterAlignment: persistentFooterAlignment,
      persistentFooterButtons: persistentFooterButtons,
      primary: primary,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      restorationId: restorationId,
      body: body,
    );

    return Stack(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > mobileBreakpointWidth &&
                navigationRail != null) {
              return Row(
                children: [
                  if (navigationRail != null && width > mobileBreakpointWidth)
                    navigationRail!,
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: scaffold),
                ],
              );
            }
            return scaffold;
          },
        ),
      ],
    );
  }
}
