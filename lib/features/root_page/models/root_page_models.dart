import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/drawers/game_filter_drawer.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/drawers/game_sorter_drawer.dart';
import 'package:pile_of_shame/features/root_page/root_analytics/widgets/root_analytics_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_analytics/widgets/root_analytics_destination.dart';
import 'package:pile_of_shame/features/root_page/root_games/widgets/root_games_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_games/widgets/root_games_destination.dart';
import 'package:pile_of_shame/features/root_page/root_games/widgets/root_games_fab.dart';
import 'package:pile_of_shame/features/root_page/root_platform_families/widgets/root_platform_families_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_platform_families/widgets/root_platform_families_destination.dart';
import 'package:pile_of_shame/features/root_page/root_settings/widgets/root_settings_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_settings/widgets/root_settings_destination.dart';

enum RootTabs {
  games,
  platformFamilies,
  analytics,
  settings,
  ;

  PreferredSizeWidget appBar(ScrollController scrollController, bool hasGames) {
    switch (this) {
      case RootTabs.games:
        return RootGamesAppBar(
          scrollController: scrollController,
        );
      case RootTabs.platformFamilies:
        return RootPlatformFamiliesAppBar();
      case RootTabs.analytics:
        return RootAnalyticsAppBar(
          hasGames: hasGames,
        );
      case RootTabs.settings:
        return RootSettingsAppBar();
    }
  }

  Widget? fab(BuildContext context, [bool isExtended = false]) {
    switch (this) {
      case RootTabs.games:
        return RootGamesFab(isExtended: isExtended);
      default:
        return null;
    }
  }

  NavigationDestination destination(BuildContext context) {
    switch (this) {
      case RootTabs.games:
        return rootGamesDestination(context);
      case RootTabs.platformFamilies:
        return rootPlatformFamiliesDestination(context);
      case RootTabs.analytics:
        return rootAnalyticsDestination(context);
      case RootTabs.settings:
        return rootSettingsDestination(context);
    }
  }

  Widget? drawer(BuildContext context) {
    switch (this) {
      case RootTabs.games:
        return const GameSorterDrawer();
      default:
        return null;
    }
  }

  Widget? endDrawer(BuildContext context) {
    switch (this) {
      case RootTabs.games:
        return const GameFilterDrawer();
      default:
        return null;
    }
  }

  Widget wrapper(Widget child) {
    // HACK: Even though this is only necessary for RootTabs.analytics, the fade through animations won't work correctly if the other tabs don't use this aswell
    return DefaultTabController(length: 3, child: child);
  }
}
