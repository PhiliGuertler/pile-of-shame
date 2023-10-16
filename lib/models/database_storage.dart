import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/utils/data_migration.dart';

/// Takes care of persisting and reading the database to and
/// from a file
class DatabaseStorage {
  final Ref ref;

  const DatabaseStorage({required this.ref});

  Future<void> persistDatabase(Database gamesList, [File? outputFile]) async {
    final encodedList = jsonEncode(gamesList.toJson());
    final File output =
        outputFile ?? await ref.read(databaseFileProvider.future);
    await output.writeAsString(encodedList);
    if (outputFile == null) {
      ref.invalidate(databaseFileProvider);
      // HACK: To avoid a weird bug in Riverpod 2.x, we have to read the provider after invalidating it. Otherwise, a bad state may occur, see https://github.com/rrousselGit/riverpod/issues/2041
      ref.read(databaseFileProvider);
    }
  }

  Future<Database> readDatabaseFromFile(File inputFile) async {
    final fileContents = await inputFile.readAsString();
    final json = jsonDecode(fileContents) as Map<String, dynamic>;
    return DatabaseMigrator.loadAndMigrateGamesFromJson(json);
  }

  Future<void> persistCurrentDatabase() async {
    final database = await ref.read(databaseProvider.future);
    final databaseFile = await ref.read(databaseFileProvider.future);
    await persistDatabase(database, databaseFile);
  }
}
