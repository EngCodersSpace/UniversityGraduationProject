import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtils {
  static const String defaultBaseFolderPath =
      "/storage/emulated/0/StudentServices";

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isRestricted || status.isLimited) {
      final result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // Optionally, open app settings
      await openAppSettings();
      return false;
    }

    return false;
  }

  static saveFiles({
    required String? fileRelativePath,
    required File file,
  }) async {
    if (fileRelativePath == null) return;
    if (!await requestStoragePermission()) {
     showSnakeBar(title: "Storage Permission Denied", message: "some functionalities maybe not work ");
      return ;
    }
    List<String>? parts = fileRelativePath.split("/");
    parts.removeLast();
    String relativePath = parts.join("/");
    Directory dir = Directory("$defaultBaseFolderPath/$relativePath");
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    await file.copy("${dir.path}/${fileRelativePath.split("/").last}");
  }

  static Future<bool> deleteFile(
      {required String? filePath, String? baseFolderPath}) async {
    if (filePath == null) return false;
    if (!await requestStoragePermission()) {
      showSnakeBar(title: "Storage Permission Denied", message: "can't delete file");
      return false;
    }
    baseFolderPath ??= defaultBaseFolderPath;
    try {
      File("$baseFolderPath/$filePath").delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  static Future<void> openFile(String? path, {String? baseFolderPath}) async {
    baseFolderPath ??= defaultBaseFolderPath;
    if (path == null) return;
    if (kIsWeb) {
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

  static checkExists(String filePath, {String? baseFolderPath}) async {
    baseFolderPath ??= defaultBaseFolderPath;
    return await File("$baseFolderPath/$filePath").exists();
  }
}
