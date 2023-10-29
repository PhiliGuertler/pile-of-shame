import "dart:io";

import "package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:googleapis/analytics/v3.dart";
import "package:googleapis/drive/v3.dart" as google_drive;
import "package:pile_of_shame/providers/database/database_file_provider.dart";
import "package:pile_of_shame/providers/database/database_provider.dart";
import "package:pile_of_shame/utils/constants.dart";
import "package:pile_of_shame/widgets/app_scaffold.dart";

class GoogleDriveSyncer {
  static const String remoteFileName = "pile-of-shame.json";
  static const String remoteDirectoryName = "PileOfShame";
  static const String googleDriveDirectoryMimeType =
      "application/vnd.google-apps.folder";

  final GoogleSignIn _googleSignIn;
  final WidgetRef ref;

  GoogleDriveSyncer({required this.ref})
      : _googleSignIn = GoogleSignIn(
          scopes: <String>[google_drive.DriveApi.driveFileScope],
        );

  Future<google_drive.DriveApi> _prepareApiClient() async {
    await _googleSignIn.signIn();
    final httpClient = (await _googleSignIn.authenticatedClient())!;
    return google_drive.DriveApi(httpClient);
  }

  Future<google_drive.File> _getRemoteAppDirectory() async {
    final api = await _prepareApiClient();

    final foundFiles = await api.files.list(
      q: "name='$remoteDirectoryName' and mimeType='$googleDriveDirectoryMimeType'",
    );
    if (foundFiles.files != null && foundFiles.files!.isNotEmpty) {
      return foundFiles.files![0];
    }
    throw Exception("No remote directory found");
  }

  Future<google_drive.File> _getAppDirectory() async {
    final api = await _prepareApiClient();

    late google_drive.File result;
    try {
      result = await _getRemoteAppDirectory();
    } catch (error) {
      // The remote directory might not exist yet, create it
      final directory = google_drive.File(
        description: "Backups of your Pile-of-Shame's games and hardware",
        name: remoteDirectoryName,
        mimeType: googleDriveDirectoryMimeType,
      );

      result = await api.files.create(directory);
    }
    return result;
  }

  Future<google_drive.File> _getRemoteFile() async {
    final api = await _prepareApiClient();

    final foundFiles = await api.files.list(q: "name='$remoteFileName'");
    if (foundFiles.files != null && foundFiles.files!.isNotEmpty) {
      return foundFiles.files![0];
    }
    throw Exception("No remote file found");
  }

  Future<google_drive.File> _updateRemoteFileContents(File file) async {
    final api = await _prepareApiClient();
    final meta = await _getRemoteFile();
    return api.files.update(
      google_drive.File(),
      meta.id!,
      uploadMedia: google_drive.Media(file.openRead(), file.lengthSync()),
    );
  }

  Future<void> uploadFileToGoogleDrive(File file) async {
    final api = await _prepareApiClient();
    final directory = await _getAppDirectory();

    late google_drive.File result;
    try {
      result = await _updateRemoteFileContents(file);
    } catch (error) {
      // The remote file has not been created yet, so let's create it
      final meta = google_drive.File(
        description:
            "Created by pile of shame as a backup of your games and hardware",
        parents: [directory.id!],
        name: remoteFileName,
      );
      result = await api.files.create(
        meta,
        uploadMedia: google_drive.Media(file.openRead(), file.lengthSync()),
      );
    }
    debugPrint(result.toJson().toString());
  }

  Future<void> downloadFileFromGoogleDrive() async {
    final api = await _prepareApiClient();

    final remoteFile = await _getRemoteFile();

    final fileId = remoteFile.id!;

    final google_drive.Media response = await api.files.get(
      fileId,
      downloadOptions: DownloadOptions.fullMedia,
    ) as google_drive.Media;

    final List<int> fileContent = await response.stream
        .reduce((previous, element) => [...previous, ...element]);

    // TODO: Create a backup of the current list of games first
    final storage = ref.read(databaseStorageProvider);
    final database = await storage.readDatabaseFromBytes(fileContent);
    await storage.persistDatabase(database);
  }
}

class TestGoogleAPIs extends ConsumerWidget {
  const TestGoogleAPIs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoogleDriveSyncer syncer = GoogleDriveSyncer(ref: ref);
    final databaseFile = ref.watch(databaseFileProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text("Google Drive Test")),
      body: ListView(
        children: [
          const Text(
            "TODO: Hier sollte das Google-Konto angezeigt werden, außerdem ein Button 'Ausloggen'/'Einloggen' je nach Login-Status",
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPaddingX),
            child: Text(
              "Deine synchronisierte Spiele-Datei wird in Deinem Google-Drive unter '${GoogleDriveSyncer.remoteDirectoryName}/${GoogleDriveSyncer.remoteFileName}' gespeichert.",
            ),
          ),
          databaseFile.when(
            data: (databaseFile) => ElevatedButton(
              child: const Text("Upload Games to Google Drive"),
              onPressed: () async {
                await syncer.uploadFileToGoogleDrive(databaseFile);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("File uploaded successfully!"),
                    ),
                  );
                }
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
          ),
          ElevatedButton(
            onPressed: () async {
              await syncer.downloadFileFromGoogleDrive();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("File downloaded successfully")),
                );
              }
            },
            child: const Text("Download google drive file"),
          ),
        ],
      ),
    );
  }
}
