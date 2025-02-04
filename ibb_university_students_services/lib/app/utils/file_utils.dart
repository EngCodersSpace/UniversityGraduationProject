import 'dart:io';


class FileUtils {
  static const String baseFolderPath = "storage/emulated/0/StudentServices";

  static saveFiles({
    required String fileRelativePath,
    required  file,
    String baseFolderPath = "/storage/emulated/0/StudentServices",
  }) async {
    List<String>? parts = fileRelativePath.split("/");
    parts.removeLast();
    String relativePath = parts.join("/");
    Directory dir = Directory("$baseFolderPath/$relativePath");
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    await file.copy(
        "${dir.path}/${fileRelativePath.split("/").last}");
  }

  static deleteFiles({
    required List<String> filesPath,
  }) async {
    for (String path in filesPath) {
      File(path).delete();
    }
  }


  static checkExists(String filePath,{String? subPath})async{
    return await File("$baseFolderPath$subPath/$filePath").exists();
  }
}
