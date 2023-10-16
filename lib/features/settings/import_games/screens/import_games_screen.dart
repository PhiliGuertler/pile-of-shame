import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

class ImportGamesScreen extends ConsumerStatefulWidget {
  const ImportGamesScreen({super.key});

  @override
  ConsumerState<ImportGamesScreen> createState() => _ImportGamesScreenState();
}

class _ImportGamesScreenState extends ConsumerState<ImportGamesScreen> {
  bool isLoading = false;

  Future<void> importGames(
    Future<Database> Function(File file) processGames,
  ) async {
    setState(() {
      isLoading = true;
    });
    final pickedFile = await ref.read(fileUtilsProvider).pickFile();
    if (pickedFile != null) {
      try {
        final games = await processGames(pickedFile);

        await ref.read(databaseStorageProvider).persistDatabase(games);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.importSuccessful),
            ),
          );
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          throw Exception(AppLocalizations.of(context)!.importFailed);
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.importCancelled),
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trailing = isLoading
        ? const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(),
          )
        : const Icon(Icons.file_download);

    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.importGames),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: defaultPaddingX,
                  right: defaultPaddingX,
                  top: 24.0,
                  bottom: 16.0,
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .beforeYouImportGamesYouShouldExportYourPreviousGamesAsAPrecaution,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SegmentedActionCard(
                items: [
                  SegmentedActionCardItem(
                    trailing: trailing,
                    title:
                        Text(AppLocalizations.of(context)!.importAndOverride),
                    subtitle: Text(
                      AppLocalizations.of(context)!
                          .yourPreviousGamesWillBeDeleted,
                    ),
                    onTap: isLoading
                        ? null
                        : () => importGames(
                              (File pickedFile) async {
                                final gameStorage =
                                    ref.read(databaseStorageProvider);
                                return gameStorage
                                    .readDatabaseFromFile(pickedFile);
                              },
                            ),
                  ),
                  SegmentedActionCardItem(
                    trailing: trailing,
                    title: Text(AppLocalizations.of(context)!.importAndUpdate),
                    subtitle: Text(
                      "${AppLocalizations.of(context)!.gamesInYourListThatAreOlderThanImportedGamesWillBeOverwritten} ${AppLocalizations.of(context)!.gamesThatAreNotInYourListWillBeImported}",
                    ),
                    onTap: isLoading
                        ? null
                        : () => importGames(
                              (File pickedFile) async {
                                final gameStorage =
                                    ref.read(databaseStorageProvider);
                                final Database importedGames = await gameStorage
                                    .readDatabaseFromFile(pickedFile);

                                final existingGames =
                                    await ref.read(databaseProvider.future);

                                final update =
                                    existingGames.updateDatabaseByLastModified(
                                  importedGames,
                                );
                                return update
                                    .addMissingDatabaseEntries(importedGames);
                              },
                            ),
                  ),
                  SegmentedActionCardItem(
                    trailing: trailing,
                    title:
                        Text(AppLocalizations.of(context)!.updateExistingGames),
                    subtitle: Text(
                      AppLocalizations.of(context)!
                          .gamesInYourListThatAreOlderThanImportedGamesWillBeOverwritten,
                    ),
                    onTap: isLoading
                        ? null
                        : () => importGames(
                              (File pickedFile) async {
                                final gameStorage =
                                    ref.read(databaseStorageProvider);
                                final Database importedGames = await gameStorage
                                    .readDatabaseFromFile(pickedFile);

                                final Database database =
                                    await ref.read(databaseProvider.future);

                                return database.updateDatabaseByLastModified(
                                  importedGames,
                                );
                              },
                            ),
                  ),
                  SegmentedActionCardItem(
                    trailing: trailing,
                    title: Text(
                      AppLocalizations.of(context)!.importMissingGamesOnly,
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context)!
                          .gamesThatAreNotInYourListWillBeImported,
                    ),
                    onTap: isLoading
                        ? null
                        : () => importGames(
                              (File pickedFile) async {
                                final gameStorage =
                                    ref.read(databaseStorageProvider);
                                final Database importedGames = await gameStorage
                                    .readDatabaseFromFile(pickedFile);

                                final Database database =
                                    await ref.read(databaseProvider.future);

                                return database
                                    .addMissingDatabaseEntries(importedGames);
                              },
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
