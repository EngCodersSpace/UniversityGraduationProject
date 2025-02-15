import 'package:ibb_university_students_services/app/services/http_provider/http_provider.dart';
import 'package:workmanager/workmanager.dart';

class WorkManager{

  static void init()async{
    await Workmanager().initialize(_callbackDispatcher, isInDebugMode: true);
  }

  static void _callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      if (task == "uploadTask") {
        HttpProvider.uploadFile(file:inputData!["file"],uploadUrl:inputData["uploadUrl"], onSendProgress: inputData["onSendProgress"]);
      } else if (task == "downloadTask") {
        // HttpProvider.uploadFile(file:inputData!["file"],uploadUrl:inputData["uploadUrl"], onSendProgress: inputData["onSendProgress"]);
      }
      return Future.value(true);
    });
  }
}