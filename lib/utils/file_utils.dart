import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<File> createTemporaryFile(String fileName) async {
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final filePath = "$path/$fileName";
    final file = File(filePath);
    if (await file.exists()) {
      throw Exception('Requested File "$fileName" already exists');
    }
    return file;
  }

  Future<File?> pickFile() async {
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();

    if (pickedFile != null && pickedFile.files.single.path != null) {
      final File result = File(pickedFile.files.single.path!);
      return result;
    }
    return null;
  }

  Future<bool> _exportFileDesktop(
    File file,
    String fileName,
    String dialogTitle,
  ) async {
    final String? outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
    );

    if (outputFilePath == null) {
      // User cancelled the process
      return false;
    }

    final fileContents = await file.readAsString();

    final output = File(outputFilePath);
    await output.writeAsString(fileContents);
    return true;
  }

  Future<bool> shareFile(File file, String fileName, String dialogTitle) async {
    final File tmpFile = await createTemporaryFile(fileName);
    await tmpFile.writeAsString(await file.readAsString());

    final xFile = XFile(
      tmpFile.path,
      mimeType: 'application/json',
      name: fileName,
    );
    final result = await Share.shareXFiles([xFile], subject: dialogTitle);

    await tmpFile.delete();

    return result.status == ShareResultStatus.success;
  }

  Future<bool> _exportFileMobile(
    File file,
    String fileName,
    String dialogTitle,
  ) async {
    final response = await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        fileName: fileName,
        sourceFilePath: file.path,
      ),
    );
    return response != null;
  }

  Future<bool> exportFile(
    File file,
    String fileName,
    String dialogTitle,
  ) async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return _exportFileDesktop(file, fileName, dialogTitle);
    } else {
      return _exportFileMobile(file, fileName, dialogTitle);
    }
  }
}
