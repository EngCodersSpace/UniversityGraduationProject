import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadManager {

  static String downloadBasePath = "";
  // Initialize the downloader
  static Future<void> initialize() async {
    await FlutterDownloader.initialize(debug: true);
    downloadBasePath =  "/storage/emulated/0/StudentServices";
  }

  // Fetch the base download directory
  static Future<String> getDownloadsFolderPath() async {
    if (Platform.isAndroid) {
      // Request storage permission
      if (await Permission.storage.request().isGranted) {
        final downloadsPath = Directory('/storage/emulated/0/Download/StudentServices');
        if (!await downloadsPath.exists()) {
          await downloadsPath.create(recursive: true);
        }
        if (await downloadsPath.exists()) {
          return downloadsPath.path;
        } else {
          throw Exception('Downloads folder not found');
        }
      } else {
        throw Exception('Storage permission denied');
      }
    } else if (Platform.isIOS) {
      // For iOS, use the app's document directory as a fallback
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  // Start a download task
  static Future<String?> startDownload(String url, String fileName , {String? savePath}) async {

    Directory dir = Directory("$downloadBasePath/$savePath");
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir.path,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: false,
    );
    return taskId;
  }

  // Cancel a download task
  static Future<void> cancelDownload(String taskId) async {
    await FlutterDownloader.cancel(taskId: taskId);
  }

  // Pause a download task
  static Future<void> pauseDownload(String taskId) async {
    await FlutterDownloader.pause(taskId: taskId);
  }

  // Resume a download task
  static Future<void> resumeDownload(String taskId) async {
    await FlutterDownloader.resume(taskId: taskId);
  }

  // Check the status of a download task
  static Future<DownloadTaskStatus?> getDownloadStatus(String taskId) async {
    final task = await FlutterDownloader.loadTasksWithRawQuery(query: 'SELECT * FROM task WHERE task_id="$taskId"');
    return (task?.isNotEmpty??false) ? task?.first.status : null;
  }

  // Get download progress
  static Future<int?> getDownloadProgress(String taskId) async {
    final task = await FlutterDownloader.loadTasksWithRawQuery(query: 'SELECT * FROM task WHERE task_id="$taskId"');
    return (task?.isNotEmpty??false) ? task?.first.progress : null;
  }

  // Check if a task is complete
  static Future<bool> isDownloadComplete(String taskId) async {
    final task = await FlutterDownloader.loadTasksWithRawQuery(query: 'SELECT * FROM task WHERE task_id="$taskId"');
    return (task?.isNotEmpty??false) && task?.first.status == DownloadTaskStatus.complete;
  }
}
