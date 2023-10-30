import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:pile_of_shame/api/providers/google_drive_providers.dart";
import "package:pile_of_shame/l10n/generated/app_localizations.dart";
import "package:pile_of_shame/providers/database/database_file_provider.dart";
import "package:pile_of_shame/utils/constants.dart";
import "package:pile_of_shame/widgets/app_scaffold.dart";

class GoogleDriveScreen extends ConsumerStatefulWidget {
  const GoogleDriveScreen({super.key});

  @override
  ConsumerState<GoogleDriveScreen> createState() => _GoogleDriveScreenState();
}

class _GoogleDriveScreenState extends ConsumerState<GoogleDriveScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final GoogleDriveSyncer syncer = ref.watch(googleDriveSyncerProvider);
    final GoogleSignInAccount? currentUser = ref.watch(googleUserProvider);
    final databaseFile = ref.watch(databaseFileProvider);

    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.cloudBackup)),
      body: ListView(
        children: [
          if (currentUser != null)
            ListTile(
              title: Text(currentUser.email),
              leading: CircleAvatar(
                backgroundImage: currentUser.photoUrl != null
                    ? NetworkImage(currentUser.photoUrl!)
                    : null,
                child: currentUser.photoUrl == null
                    ? Text(currentUser.displayName?[0] ?? '')
                    : null,
              ),
              trailing: IconButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        await syncer.logOut();
                      },
                icon: const Icon(Icons.logout),
              ),
            ),
          if (currentUser == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPaddingX),
              child: ElevatedButton(
                onPressed: () async {
                  await syncer.logIn();
                },
                child: Text(
                  l10n.logInWithGoogle,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
              vertical: 16.0,
            ),
            child: Text(
              l10n.explainGoogleDriveSync,
            ),
          ),
          databaseFile.when(
            data: (databaseFile) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                onPressed: currentUser != null && !isLoading
                    ? () async {
                        setState(() {
                          isLoading = true;
                        });
                        await syncer.uploadFileToGoogleDrive(databaseFile);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.databaseUploadedSuccessfully),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    : null,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: isLoading
                          ? const SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.cloud_upload),
                    ),
                    Expanded(child: Text(l10n.uploadDatabaseToGoogleDrive)),
                  ],
                ),
              ),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
              vertical: 8.0,
            ),
            child: ElevatedButton(
              onPressed: currentUser != null && !isLoading
                  ? () async {
                      setState(() {
                        isLoading = true;
                      });
                      await syncer.downloadFileFromGoogleDrive();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.databaseDownloadedSuccessfully),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  : null,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: isLoading
                        ? const SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Icons.cloud_download),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(l10n.downloadDatabaseFromGoogleDrive),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
