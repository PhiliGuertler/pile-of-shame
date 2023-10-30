import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pile_of_shame/features/developer_tools/debug_menu/screens/debug_menu_screen.dart';
import 'package:pile_of_shame/features/settings/about/screens/about_screen.dart';
import 'package:pile_of_shame/features/settings/appearance/screens/appearance_screen.dart';
import 'package:pile_of_shame/features/settings/currency/screens/currency_screen.dart';
import 'package:pile_of_shame/features/settings/export_games/screens/export_games_screen.dart';
import 'package:pile_of_shame/features/settings/game_display/screens/game_display_screen.dart';
import 'package:pile_of_shame/features/settings/google_drive/screens/google_drive_screen.dart';
import 'package:pile_of_shame/features/settings/import_games/screens/import_games_screen.dart';
import 'package:pile_of_shame/features/settings/language/screens/language_screen.dart';
import 'package:pile_of_shame/features/settings/platforms/screens/platforms_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/debug_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/utils/debug/debug_secret_code_input.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_header.dart';

class SettingsScreen extends ConsumerWidget {
  final ScrollController scrollController;

  const SettingsScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorContainer = Theme.of(context).colorScheme.errorContainer;
    final onErrorContainer = Theme.of(context).colorScheme.onErrorContainer;

    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          const SliverFancyImageHeader(
            imageAsset: ImageAssets.gear,
            height: 250,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: 8.0,
              ),
              child: Text(
                l10n.appSettings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SegmentedActionCard(
              items: [
                SegmentedActionCardItem(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(l10n.appearance),
                  subtitle: Text(l10n.comeToTheDarkSide),
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
                  title: Text(l10n.language),
                  subtitle: Text(l10n.languageSubtitle),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LanguageScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.currency_exchange),
                  title: Text(l10n.currency),
                  subtitle: Text(l10n.chooseACurrencySymbol),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CurrencyScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.sports_esports),
                  title: Text(l10n.gameDisplay),
                  subtitle: Text(
                    l10n.personalizeGameDisplays,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GameDisplayScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.videogame_asset),
                  title: Text(l10n.yourPlatforms),
                  subtitle: Text(l10n.selectYourPlatforms),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PlatformsScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.info),
                  title: Text(l10n.aboutThisApp),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
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
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: 8.0,
              ),
              child: Text(
                l10n.importExport,
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
                  title: Text(l10n.importDatabase),
                  subtitle: Text(
                    l10n.importDatabaseFromAJSONFile,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ImportGamesScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.file_upload),
                  title: Text(l10n.exportDatabase),
                  subtitle: Text(
                    l10n.exportDatabaseToAJSONFile,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ExportGamesScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: const Icon(Icons.cloud),
                  title: Text(l10n.cloudBackup),
                  subtitle: Text(
                    l10n.uploadDatabaseToGoogleDrive,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GoogleDriveScreen(),
                      ),
                    );
                  },
                ),
                SegmentedActionCardItem(
                  leading: Icon(
                    Icons.delete_forever,
                    color: onErrorContainer,
                  ),
                  title: Text(
                    l10n.deleteDatabase,
                    style: TextStyle(color: onErrorContainer),
                  ),
                  trailing: Icon(
                    Icons.warning,
                    color: onErrorContainer,
                  ),
                  tileColor: errorContainer,
                  subtitle: Text(
                    l10n.thisActionCannotBeUndone,
                    style: TextStyle(color: onErrorContainer),
                  ),
                  onTap: () async {
                    final bool? response = await showAdaptiveDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog.adaptive(
                        title: Text(
                          l10n.deleteAllGamesAndHardware,
                        ),
                        content: Text(
                          l10n.thisActionCannotBeUndone,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(l10n.yes),
                          ),
                        ],
                      ),
                    );
                    if (response != null && response) {
                      final databaseStorage = ref.read(databaseStorageProvider);
                      databaseStorage.persistDatabase(
                        const Database(games: [], hardware: []),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.allGamesDeleted,
                            ),
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
