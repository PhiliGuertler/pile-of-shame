import 'dart:convert';

import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/database_storage.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';
import 'package:pile_of_shame/utils/data_migration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Database> database(Ref ref) async {
  final databaseFile = await ref.watch(databaseFileProvider.future);

  final content = await databaseFile.readAsString();

  if (content.isNotEmpty) {
    final Map<String, dynamic> jsonMap =
        jsonDecode(content) as Map<String, dynamic>;
    return DatabaseMigrator.loadAndMigrateGamesFromJson(jsonMap);
  }
  return const Database(games: [], hardware: []);
}

@Riverpod(keepAlive: true)
DatabaseStorage databaseStorage(Ref ref) =>
    DatabaseStorage(ref: ref);
