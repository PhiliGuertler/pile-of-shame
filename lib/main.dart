import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/developer_tools/debug_game_platforms/screens/debug_game_platforms_screens.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.system,
      localizationsDelegates: [...AppLocalizations.localizationsDelegates],
      home: DebugGamePlatformsScreens(),
    );
  }
}
