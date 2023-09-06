import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';

class ExportGamesScreen extends ConsumerStatefulWidget {
  const ExportGamesScreen({super.key});

  @override
  ConsumerState<ExportGamesScreen> createState() => _ExportGamesScreenState();
}

class _ExportGamesScreenState extends ConsumerState<ExportGamesScreen> {
  bool isLoading = false;

  Future<void> exportGames() async {
    setState(() {
      isLoading = true;
    });
    final exportGamesTitle = AppLocalizations.of(context)!.exportGames;
    String currentDateTime = DateTime.now().toIso8601String();
    currentDateTime = currentDateTime.replaceFirst("T", "_");
    currentDateTime = currentDateTime.replaceAll(":", "-");
    currentDateTime = currentDateTime.split(".").first;
    final gamesFile = await ref.read(gameFileProvider.future);

    try {
      final pickedFile = await ref.read(fileUtilsProvider).exportFile(
          gamesFile, 'games-$currentDateTime.json', exportGamesTitle);
      if (pickedFile) {
        if (context.mounted) {
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
      if (context.mounted) {
        throw Exception(AppLocalizations.of(context)!.exportFailed);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> shareGames() async {
    setState(() {
      isLoading = true;
    });
    final exportGamesTitle = AppLocalizations.of(context)!.exportGames;
    String currentDateTime = DateTime.now().toIso8601String();
    currentDateTime = currentDateTime.replaceFirst("T", "_");
    currentDateTime = currentDateTime.replaceAll(":", "-");
    currentDateTime = currentDateTime.split(".").first;
    final gamesFile = await ref.read(gameFileProvider.future);

    try {
      final pickedFile = await ref.read(fileUtilsProvider).shareFile(
          gamesFile, 'games-$currentDateTime.json', exportGamesTitle);
      if (pickedFile) {
        if (context.mounted) {
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
      if (context.mounted) {
        throw Exception(AppLocalizations.of(context)!.exportFailed);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.exportGames),
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
                            child: CircularProgressIndicator())
                        : const Icon(Icons.file_upload),
                    title: Text(AppLocalizations.of(context)!.exportAll),
                    subtitle: Text(AppLocalizations.of(context)!
                        .exportAllGamesIntoAJSONFile),
                    onTap: isLoading ? null : () => exportGames(),
                  ),
                  SegmentedActionCardItem(
                    trailing: isLoading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator())
                        : const Icon(Icons.share),
                    title: Text(AppLocalizations.of(context)!.shareGames),
                    subtitle: Text(
                        AppLocalizations.of(context)!.shareGamesAsAJSONFile),
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
