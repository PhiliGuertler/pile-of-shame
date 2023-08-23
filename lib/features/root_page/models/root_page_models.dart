import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/root_page/root_games/root_games_app_bar.dart';
import 'package:pile_of_shame/features/root_page/root_settings/root_settings_app_bar.dart';

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
}
