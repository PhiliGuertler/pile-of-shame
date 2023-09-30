import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/screens/analytics_root_content_screen.dart';
import 'package:pile_of_shame/features/games/games_list/screens/games_screen.dart';
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
  late ScrollController _scrollControllerGames;
  bool isScrolled = false;
  RootTabs activeTab = RootTabs.games;

  void _handleRootTabChange(int index, BuildContext context) {
    if (index == RootTabs.games.index) {
      if (index == activeTab.index) {
        _scrollControllerGames.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }

    setState(() {
      activeTab = RootTabs.values[index];
    });
  }

  void handleScroll() {
    final offset = _scrollControllerGames.offset;
    final minScrollExtent = _scrollControllerGames.position.minScrollExtent;
    final bool result = offset > minScrollExtent;
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
    final hasGames = ref.watch(hasGamesProvider);

    final destinations =
        RootTabs.values.map((e) => e.destination(context)).toList();

    final children = [
      GamesScreen(scrollController: _scrollControllerGames),
      const LibraryScreen(),
      const AnalyticsRootContentScreen(),
      const SettingsScreen(),
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
        floatingActionButton: activeTab.fab(context, !isScrolled),
        appBar: activeTab.appBar(
          _scrollControllerGames,
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
