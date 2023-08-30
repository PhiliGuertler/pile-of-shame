import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/root_page/root_games/root_games_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_settings/root_settings_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_settings/root_settings_destination.dart';

import '../root_games/root_games_destination.dart';
import '../root_games/root_games_fab.dart';

enum RootTabs {
  games,
  settings,
  ;

  PreferredSizeWidget appBar() {
    switch (this) {
      case RootTabs.games:
        return RootGamesAppBar();
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
      case RootTabs.settings:
        return rootSettingsDestination(context);
    }
  }
}
