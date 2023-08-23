import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/screens/games_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

import 'models/root_page_models.dart';

class RootPage extends ConsumerStatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const RootPage({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  bool isScrolled = false;
  RootTabs activeTab = RootTabs.games;

  void _handleRootTabChange(int index, BuildContext context) {
    if (index == RootTabs.games.index) {
      setState(() {
        activeTab = RootTabs.games;
      });
    }
    if (index == RootTabs.settings.index) {
      setState(() {
        activeTab = RootTabs.settings;
      });
    }
  }

  void handleScroll() {
    final offset = widget.scrollController.offset;
    final minScrollExtent = widget.scrollController.position.minScrollExtent;
    bool result = offset > minScrollExtent;
    setState(() {
      isScrolled = result;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinations = [
      NavigationDestination(
        key: const ValueKey('games'),
        icon: const Icon(Icons.gamepad_outlined),
        selectedIcon: const Icon(Icons.gamepad)
            .animate()
            .scale(
              end: const Offset(1.5, 1.5),
              curve: Curves.bounceOut,
              duration: 200.ms,
            )
            .then(duration: 70.ms)
            .moveX(begin: 0.0, end: 10.0)
            .then()
            .moveX(begin: 0.0, end: -10.0)
            .then()
            .moveX(begin: 0.0, end: 10.0)
            .then()
            .moveX(begin: 0.0, end: -10.0)
            .then()
            .moveY(begin: 0.0, end: -10.0)
            .then()
            .moveY(begin: 0.0, end: 10.0)
            .then(duration: 200.ms)
            .scale(
              end: const Offset(1.0 / 1.5, 1.0 / 1.5),
              curve: Curves.bounceOut,
            ),
        label: AppLocalizations.of(context)!.games,
      ),
      NavigationDestination(
          key: const ValueKey('settings'),
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings_rounded)
              .animate()
              .rotate(begin: 0, end: 2.0 / 6.0)
              .moveY(begin: -10.0, end: 0.0, curve: Curves.bounceOut)
              .scale(end: const Offset(1.5, 1.5))
              .then()
              .scale(end: const Offset(1.0 / 1.5, 1.0 / 1.5)),
          label: AppLocalizations.of(context)!.settings),
    ];

    final children = [
      const GamesScreen(),
      Container(
        color: Colors.orange,
        child: const Text('TODO: Implement settings'),
      ),
    ];

    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
        child: Container(
            key: ValueKey(activeTab.index), child: children[activeTab.index]),
      ),
      appBar: activeTab.appBar(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: activeTab.index,
        onDestinationSelected: (index) => _handleRootTabChange(index, context),
        destinations: destinations,
      ),
    );
  }
}
