
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
    this.section,
    this.createdAt,
    this.updatedAt,
  });

  String? get name {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return nameData?[currentLang];
  }

}




