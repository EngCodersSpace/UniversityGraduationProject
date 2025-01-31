import 'dart:io';


class FileUtils {
  static const String baseFolderPath = "storage/emulated/0/StudentServices";

  static saveFiles({
    required String fileRelativePath,
    required List<File> files,
    String baseFolderPath = "/storage/emulated/0/StudentServices",
  }) async {
    Directory dir = Directory("$baseFolderPath/$fileRelativePath");
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    for (File file in files) {
      await file.copy(
          "${dir.path}/${file.path.split("/").last}");
    }
  }

  static deleteFiles({
    required List<String> filesPath,
  }) async {
    for (String path in filesPath) {
      File(path).delete();
    }
  }
}
