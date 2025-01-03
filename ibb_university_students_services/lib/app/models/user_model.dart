
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';

abstract class User {
  int id;
  Map<String,dynamic>? nameData;
  String? dateOfBrith;
  String? email;
  String? permission;
  String? profileImage;
  List<String>? phones;
  Map<String,dynamic>? collegeNameData;
  Section? section;
  String? createdAt;
  String? updatedAt;

  User({
    required this.id,
    this.nameData,
    this.dateOfBrith,
    this.email,
    this.permission,
    this.profileImage,
    this.phones,
    this.collegeNameData,
    this.section,
    this.createdAt,
    this.updatedAt,
  });

  String? get name {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return nameData?[currentLang];
  }

  String? get collegeName {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return collegeNameData?[currentLang];
  }

}




