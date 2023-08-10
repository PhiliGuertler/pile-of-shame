import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

  Future<File?> pickFile() async {
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();

    if (pickedFile != null && pickedFile.files.single.path != null) {
      File result = File(pickedFile.files.single.path!);
      return result;
    }
    return null;
  }
}
