import 'dart:io';
import 'package:open_filex/open_filex.dart';

class FileUtils {
  static const String baseFolderPath = "/storage/emulated/0/StudentServices";

  static saveFiles({
    required String? fileRelativePath,
    required file,
  }) async {
    if (fileRelativePath == null) return;
    List<String>? parts = fileRelativePath.split("/");
    parts.removeLast();
    String relativePath = parts.join("/");
    Directory dir = Directory("$baseFolderPath/$relativePath");
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    await file.copy("${dir.path}/${fileRelativePath.split("/").last}");
  }

  static deleteFiles({
    required List<String> filesPath,
  }) async {
    for (String path in filesPath) {
      File(path).delete();
    }
  }

  static Future<void> openFile(String? path) async {
    if (path == null) return;

    final result = await OpenFilex.open("$baseFolderPath/$path");
    if (result.type == ResultType.error) {
      print("Error opening file: ${result.message}");
    }

  }

  static checkExists(String filePath) async {
    return await File("$baseFolderPath/$filePath").exists();
  }
}
