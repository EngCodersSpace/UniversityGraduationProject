import 'dart:io';

import 'package:ibb_university_students_services/app/services/http_provider/http_provider.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundRunner{

  static void startBackGroundUpload({
    required File file,
    required String uploadUrl,
    required void Function(int, int)? onSendProgress,
    int? fileSize,
}){
    if(Platform.isAndroid){
      Workmanager().registerOneOffTask(
        "uploadTaskStarter",
        "uploadTask",
        inputData: {"file":file, "uploadUrl": uploadUrl,"onSendProgress":onSendProgress,},
      );
    }else if(Platform.isIOS){
      throw UnimplementedError();
    }
  }
}