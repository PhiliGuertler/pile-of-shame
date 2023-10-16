import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/debug_provider.dart';
import 'package:pile_of_shame/providers/shared_content_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

class ImportSharedGames extends ConsumerStatefulWidget {
  const ImportSharedGames({super.key});

  @override
  ConsumerState<ImportSharedGames> createState() => _ImportSharedGamesState();
}

class _ImportSharedGamesState extends ConsumerState<ImportSharedGames> {
  bool isLoading = false;

  void leaveScreen() {
    ref.read(sharedContentProvider.notifier).setFiles([]);
  }

  Future<void> importSharedGames(
    Future<Database> Function(File file) processGames,
  ) async {
    setState(() {
      isLoading = true;
    });
    final sharedFiles = ref.read(sharedContentProvider);
    if (sharedFiles.isEmpty && sharedFiles.first.value != null) {
      throw Exception("No shared file found");
    }

    final File sharedFile = File(sharedFiles.first.value!);
    try {
      final games = await processGames(sharedFile);

      await ref.read(databaseStorageProvider).persistDatabase(games);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.importSuccessful),
          ),
        );
        leaveScreen();
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        throw Exception(AppLocalizations.of(context)!.importFailed);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedContent = ref.watch(sharedContentProvider);
    final isDebugMode = ref.watch(debugFeatureAccessProvider);

    final trailing = isLoading
        ? const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(),
          )
        : const Icon(Icons.file_download);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Dialog(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPaddingX,
                  vertical: 16.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppLocalizations.of(context)!.importGames,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
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
              if (isDebugMode)
                SliverList.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPaddingX,
                      vertical: 8.0,
                    ),
                    child: Text(sharedContent[index].value ?? 'unknown file'),
                  ),
                  itemCount: sharedContent.length,
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
                          : () => importSharedGames(
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
                      title:
                          Text(AppLocalizations.of(context)!.importAndUpdate),
                      subtitle: Text(
                        "${AppLocalizations.of(context)!.gamesInYourListThatAreOlderThanImportedGamesWillBeOverwritten} ${AppLocalizations.of(context)!.gamesThatAreNotInYourListWillBeImported}",
                      ),
                      onTap: isLoading
                          ? null
                          : () => importSharedGames(
                                (File pickedFile) async {
                                  final gameStorage =
                                      ref.read(databaseStorageProvider);
                                  final Database importedGames =
                                      await gameStorage
                                          .readDatabaseFromFile(pickedFile);

                                  final Database database =
                                      await ref.read(databaseProvider.future);

                                  final update = database
                                      .updateGamesByLastModified(importedGames);
                                  return update.addMissingGames(importedGames);
                                },
                              ),
                    ),
                    SegmentedActionCardItem(
                      trailing: trailing,
                      title: Text(
                        AppLocalizations.of(context)!.updateExistingGames,
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context)!
                            .gamesInYourListThatAreOlderThanImportedGamesWillBeOverwritten,
                      ),
                      onTap: isLoading
                          ? null
                          : () => importSharedGames(
                                (File pickedFile) async {
                                  final gameStorage =
                                      ref.read(databaseStorageProvider);
                                  final Database importedGames =
                                      await gameStorage
                                          .readDatabaseFromFile(pickedFile);

                                  final Database database =
                                      await ref.read(databaseProvider.future);

                                  return database
                                      .updateGamesByLastModified(importedGames);
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
                          : () => importSharedGames(
                                (File pickedFile) async {
                                  final gameStorage =
                                      ref.read(databaseStorageProvider);
                                  final Database importedGames =
                                      await gameStorage
                                          .readDatabaseFromFile(pickedFile);

                                  final Database database =
                                      await ref.read(databaseProvider.future);

                                  return database
                                      .addMissingGames(importedGames);
                                },
                              ),
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPaddingX,
                    vertical: 16.0,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () {
                        leaveScreen();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade();
  }
}
