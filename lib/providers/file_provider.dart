import 'package:pile_of_shame/utils/file_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_provider.g.dart';

@riverpod
FileUtils fileUtils(FileUtilsRef ref) => FileUtils();
