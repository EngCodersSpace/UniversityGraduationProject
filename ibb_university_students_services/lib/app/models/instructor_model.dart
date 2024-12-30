
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';

abstract class User {
  int id;
  Map<String,dynamic>? nameData;
  User({
    required this.id,
    this.nameData,
  });

  String? get name {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return nameData?[currentLang];
  }

}




