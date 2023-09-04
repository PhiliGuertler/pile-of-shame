import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/screens/games_screen.dart';
import 'package:pile_of_shame/features/settings/root/screens/settings_screen.dart';

import 'models/root_page_models.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({
    super.key,
  });

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  late ScrollController _scrollControllerGames;
  bool isScrolled = false;
  RootTabs activeTab = RootTabs.games;

  void _handleRootTabChange(int index, BuildContext context) {
    if (index == RootTabs.games.index) {
      if (index == activeTab.index) {
        _scrollControllerGames.animateTo(0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
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
    final offset = _scrollControllerGames.offset;
    final minScrollExtent = _scrollControllerGames.position.minScrollExtent;
    bool result = offset > minScrollExtent;
    setState(() {
      isScrolled = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollControllerGames = ScrollController();
    _scrollControllerGames.addListener(handleScroll);
  }

  @override
  void dispose() {
    _scrollControllerGames.removeListener(handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinations = [
      RootTabs.games.destination(context),
      RootTabs.settings.destination(context),
    ];

    final children = [
      GamesScreen(scrollController: _scrollControllerGames),
      const SettingsScreen(),
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
      floatingActionButton: activeTab.fab(context, !isScrolled),
      appBar: activeTab.appBar(_scrollControllerGames),
      bottomNavigationBar: NavigationBar(
        selectedIndex: activeTab.index,
        onDestinationSelected: (index) => _handleRootTabChange(index, context),
        destinations: destinations,
      ),
      drawer: activeTab.drawer(context),
      endDrawer: activeTab.endDrawer(context),
    );
  }
}
