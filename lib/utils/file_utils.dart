import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  Future<File> openFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final filePath = '$path/$fileName';
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }
    return file;
  }
}
