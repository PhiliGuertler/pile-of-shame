import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';

class ExportGamesScreen extends ConsumerStatefulWidget {
  const ExportGamesScreen({super.key});

  @override
  ConsumerState<ExportGamesScreen> createState() => _ExportGamesScreenState();
}

class _ExportGamesScreenState extends ConsumerState<ExportGamesScreen> {
  bool isLoading = false;

  Future<void> handleExport(
    Future<bool> Function(File inputFile, String fileName, String title)
        callback,
  ) async {
    setState(() {
      isLoading = true;
    });
    String currentDateTime = DateTime.now().toIso8601String();
    currentDateTime = currentDateTime.replaceFirst("T", "_");
    currentDateTime = currentDateTime.replaceAll(":", "-");
    currentDateTime = currentDateTime.split(".").first;
    final databaseFile = await ref.read(databaseFileProvider.future);

    try {
      final success = await callback(
        databaseFile,
        'games-$currentDateTime.json',
        'games-$currentDateTime.json',
      );
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.exportSucceeded),
            ),
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        throw Exception(AppLocalizations.of(context)!.exportFailed);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> exportGames() async {
    return handleExport(
      (inputFile, fileName, title) async =>
          ref.read(fileUtilsProvider).exportFile(inputFile, fileName, title),
    );
  }

  Future<void> shareGames() async {
    return handleExport(
      (inputFile, fileName, title) async =>
          ref.read(fileUtilsProvider).shareFile(inputFile, fileName, title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.exportDatabase),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SegmentedActionCard(
                items: [
                  SegmentedActionCardItem(
                    trailing: isLoading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Icons.file_upload),
                    title: Text(AppLocalizations.of(context)!.exportAll),
                    subtitle: Text(
                      AppLocalizations.of(context)!.exportDatabaseToAJSONFile,
                    ),
                    onTap: isLoading ? null : () => exportGames(),
                  ),
                  SegmentedActionCardItem(
                    trailing: isLoading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Icons.share),
                    title: Text(AppLocalizations.of(context)!.shareDatabase),
                    subtitle: Text(
                      AppLocalizations.of(context)!.shareDatabaseAsAJSONFile,
                    ),
                    onTap: isLoading ? null : () => shareGames(),
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
