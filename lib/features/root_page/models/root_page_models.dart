import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/drawers/game_filter_drawer.dart';
import 'package:pile_of_shame/features/games/games_list/widgets/drawers/game_sorter_drawer.dart';
import 'package:pile_of_shame/features/hardware/hardware_list/widgets/drawers/hardware_sorter_drawer.dart';
import 'package:pile_of_shame/features/root_page/root_games/widgets/root_games_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_games/widgets/root_games_destination.dart';
import 'package:pile_of_shame/features/root_page/root_games/widgets/root_games_fab.dart';
import 'package:pile_of_shame/features/root_page/root_hardware/widgets/root_hardware_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_hardware/widgets/root_hardware_destination.dart';
import 'package:pile_of_shame/features/root_page/root_hardware/widgets/root_hardware_fab.dart';
import 'package:pile_of_shame/features/root_page/root_library/widgets/root_library_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_library/widgets/root_library_destination.dart';
import 'package:pile_of_shame/features/root_page/root_settings/widgets/root_settings_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_settings/widgets/root_settings_destination.dart';

enum RootTabs {
  games,
  hardware,
  library,
  settings,
  ;

  PreferredSizeWidget appBar(ScrollController scrollController) {
    switch (this) {
      case RootTabs.games:
        return RootGamesAppBar(
          scrollController: scrollController,
        );
      case RootTabs.hardware:
        return RootHardwareAppBar();
      case RootTabs.library:
        return RootLibraryAppBar();
      case RootTabs.settings:
        return RootSettingsAppBar();
    }
  }

  Widget? fab(BuildContext context, [bool isExtended = false]) {
    switch (this) {
      case RootTabs.games:
      case RootTabs.library:
        return RootGamesFab(isExtended: isExtended);
      case RootTabs.hardware:
        return RootHardwareFab(isExtended: isExtended);
      default:
        return null;
    }
  }

  NavigationDestination destination(BuildContext context) {
    switch (this) {
      case RootTabs.games:
        return rootGamesDestination(context);
      case RootTabs.hardware:
        return rootHardwareDestination(context);
      case RootTabs.library:
        return rootLibraryDestination(context);
      case RootTabs.settings:
        return rootSettingsDestination(context);
    }
  }

  Widget? drawer(BuildContext context) {
    switch (this) {
      case RootTabs.games:
        return const GameSorterDrawer();
      case RootTabs.hardware:
        return const HardwareSorterDrawer();
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
    return child;
  }
}
