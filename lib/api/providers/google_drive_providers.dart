// ignore_for_file: use_setters_to_change_properties

import "dart:io";

import "package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:googleapis/analytics/v3.dart";
import "package:googleapis/drive/v3.dart" as google_drive;
import "package:pile_of_shame/providers/database/database_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part 'google_drive_providers.g.dart';

@Riverpod(keepAlive: true)
class GoogleUser extends _$GoogleUser {
  @override
  GoogleSignInAccount? build() {
    return null;
  }

  void setUser(GoogleSignInAccount? account) {
    state = account;
  }
}

class GoogleDriveSyncer {
  static const String remoteFileName = "pile-of-shame.json";
  static const String remoteDirectoryName = "PileOfShame";
  static const String googleDriveDirectoryMimeType =
      "application/vnd.google-apps.folder";

  final GoogleSignIn _googleSignIn;
  final Ref ref;

  GoogleDriveSyncer({required this.ref})
      : _googleSignIn = GoogleSignIn(
          scopes: <String>[google_drive.DriveApi.driveFileScope],
        ) {
    // Try to sign in silently
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      ref.read(googleUserProvider.notifier).setUser(account);
    });
    _googleSignIn.signInSilently();
  }

  Future<void> logIn() async {
    await _googleSignIn.signIn();
  }

  Future<void> logOut() async {
    await _googleSignIn.signOut();
  }

  Future<google_drive.DriveApi> _prepareApiClient() async {
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

    final storage = ref.read(databaseStorageProvider);
    final database = await storage.readDatabaseFromBytes(fileContent);
    await storage.persistDatabase(database);
  }
}

@Riverpod(keepAlive: true)
GoogleDriveSyncer googleDriveSyncer(GoogleDriveSyncerRef ref) =>
    GoogleDriveSyncer(ref: ref);
