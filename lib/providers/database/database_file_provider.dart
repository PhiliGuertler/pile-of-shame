import 'dart:io';

import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_file_provider.g.dart';

const String gameFileName = "game-store.json";

@riverpod
FutureOr<File> databaseFile(Ref ref) async {
  final fileUtils = ref.watch(fileUtilsProvider);
  final file = await fileUtils.openFile(gameFileName);
  return file;
}
