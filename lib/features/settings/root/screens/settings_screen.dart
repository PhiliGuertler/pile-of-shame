import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pile_of_shame/features/developer_tools/debug_menu/screens/debug_menu_screen.dart';
import 'package:pile_of_shame/features/settings/appearance/screens/appearance_screen.dart';
import 'package:pile_of_shame/features/settings/export_games/screens/export_games_screen.dart';
import 'package:pile_of_shame/features/settings/import_games/screens/import_games_screen.dart';
import 'package:pile_of_shame/features/settings/language/screens/language_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/debug_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/utils/debug/debug_secret_code_input.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorContainer = Theme.of(context).colorScheme.errorContainer;
    final onErrorContainer = Theme.of(context).colorScheme.onErrorContainer;

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 24.0, bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!.appSettings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SegmentedActionCard(
              items: [
                SegmentedActionCardItem(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(AppLocalizations.of(context)!.appearance),
                  subtitle:
                      Text(AppLocalizations.of(context)!.comeToTheDarkSide),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AppearanceScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.translate),
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle:
                      Text(AppLocalizations.of(context)!.languageSubtitle),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LanguageScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 24.0, bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!.importExport,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SegmentedActionCard(
              items: [
                SegmentedActionCardItem.debug(
                  leading: const Icon(Icons.engineering),
                  title: const Text("Debug-Menu"),
                  subtitle: const Text("This is where the magic happens"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DebugMenuScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.file_download),
                  title: Text(AppLocalizations.of(context)!.importGames),
                  subtitle: Text(
                      AppLocalizations.of(context)!.importGamesFromAJSONFile),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ImportGamesScreen(),
                    ));
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.file_upload),
                  title: Text(AppLocalizations.of(context)!.exportGames),
                  subtitle: Text(
                      AppLocalizations.of(context)!.exportGamesToAJSONFile),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ExportGamesScreen(),
                    ));
                  },
                ),
                SegmentedActionCardItem(
                  leading: Icon(
                    Icons.delete_forever,
                    color: onErrorContainer,
                  ),
                  title: Text(AppLocalizations.of(context)!.deleteGames,
                      style: TextStyle(color: onErrorContainer)),
                  trailing: Icon(
                    Icons.warning,
                    color: onErrorContainer,
                  ),
                  tileColor: errorContainer,
                  subtitle: Text(
                    AppLocalizations.of(context)!.thisActionCannotBeUndone,
                    style: TextStyle(color: onErrorContainer),
                  ),
                  onTap: () async {
                    final bool? response = await showAdaptiveDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog.adaptive(
                        title:
                            Text(AppLocalizations.of(context)!.deleteAllGames),
                        content: Text(AppLocalizations.of(context)!
                            .thisActionCannotBeUndone),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(AppLocalizations.of(context)!.yes),
                          ),
                        ],
                      ),
                    );
                    if (response != null && response) {
                      final gameStore = ref.read(gameStorageProvider);
                      gameStore.persistGamesList(const GamesList(games: []));

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.allGamesDeleted),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(defaultPaddingX),
                child: DebugSecretCodeInput(
                  onSecretEnteredCorrectly: () {
                    final newDebugState = ref
                        .read(debugFeatureAccessProvider.notifier)
                        .toggleDebugMode();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Developer mode is now $newDebugState"),
                      ),
                    );
                  },
                  child: FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          'App-Version: ${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
