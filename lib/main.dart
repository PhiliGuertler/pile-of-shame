import 'package:flutter/material.dart';
import 'package:pile_of_shame/features/developer_tools/debug_game_platforms/screens/debug_game_platforms_screens.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  final providerContainer = ProviderContainer();

  runApp(UncontrolledProviderScope(
    container: providerContainer,
    child: const MainApp(),
  ));
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
