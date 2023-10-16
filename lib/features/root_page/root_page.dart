import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/games_list/screens/games_screen.dart';
import 'package:pile_of_shame/features/hardware/hardware_list/screens/hardware_screen.dart';
import 'package:pile_of_shame/features/library/screens/library_screen.dart';
import 'package:pile_of_shame/features/root_page/models/root_page_models.dart';
import 'package:pile_of_shame/features/settings/root/screens/settings_screen.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({
    super.key,
  });

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  late List<ScrollController> _scrollControllers;
  late List<bool> isScrolled;
  RootTabs activeTab = RootTabs.games;

  void _handleRootTabChange(int index, BuildContext context) {
    if (index == activeTab.index) {
      _scrollControllers[index].animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    setState(() {
      activeTab = RootTabs.values[index];
      for (int i = 0; i < RootTabs.values.length; ++i) {
        isScrolled[i] = false;
      }
    });
  }

  void handleScroll(int index) {
    final offset = _scrollControllers[index].offset;
    final minScrollExtent = _scrollControllers[index].position.minScrollExtent;
    final bool result = offset > minScrollExtent;
    setState(() {
      isScrolled[index] = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollControllers = [];
    isScrolled = [];
    for (int i = 0; i < RootTabs.values.length; ++i) {
      final controller = ScrollController();
      controller.addListener(() => handleScroll(i));
      _scrollControllers.add(controller);
      isScrolled.add(false);
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < RootTabs.values.length; ++i) {
      _scrollControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasGames = ref.watch(hasGamesProvider);

    final destinations =
        RootTabs.values.map((e) => e.destination(context)).toList();

    final children = [
      GamesScreen(scrollController: _scrollControllers[RootTabs.games.index]),
      HardwareScreen(
        scrollController: _scrollControllers[RootTabs.hardware.index],
      ),
      LibraryScreen(
        scrollController: _scrollControllers[RootTabs.library.index],
      ),
      SettingsScreen(
        scrollController: _scrollControllers[RootTabs.settings.index],
      ),
    ];

    return activeTab.wrapper(
      AppScaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: Container(
            key: ValueKey(activeTab.index),
            child: children[activeTab.index],
          ),
        ),
        floatingActionButton:
            activeTab.fab(context, !isScrolled[activeTab.index]),
        appBar: activeTab.appBar(
          _scrollControllers[activeTab.index],
          hasGames.maybeWhen(
            orElse: () => false,
            data: (data) => data,
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: activeTab.index,
          onDestinationSelected: (index) =>
              _handleRootTabChange(index, context),
          destinations: destinations,
        ),
        drawer: activeTab.drawer(context),
        endDrawer: activeTab.endDrawer(context),
      ),
    );
  }
}
