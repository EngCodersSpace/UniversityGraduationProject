import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';

class FileUtils {
  static const String defaultBaseFolderPath = "/storage/emulated/0/StudentServices";

  static saveFiles({
    required String? fileRelativePath,
    required file,
  }) async {
    if (fileRelativePath == null) return;
    List<String>? parts = fileRelativePath.split("/");
    parts.removeLast();
    String relativePath = parts.join("/");
    Directory dir = Directory("$defaultBaseFolderPath/$relativePath");
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

  static Future<void> openFile(String? path, {String? baseFolderPath}) async {
    baseFolderPath??=defaultBaseFolderPath;
    if (path == null) return;
    if(kIsWeb){
     return;
    }
    final OpenResult result;
    result = await OpenFilex.open("$baseFolderPath/$path");
    if (result.type == ResultType.error) {
      if (kDebugMode) {
        print("Error opening file: ${result.message}");
      }
    }

  }

  static checkExists(String filePath,{String? baseFolderPath}) async {
    return await File("$defaultBaseFolderPath/$filePath").exists();
  }
}
