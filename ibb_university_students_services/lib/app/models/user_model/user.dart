import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../section_model/section.dart';
// @HiveType(typeId: 0)
abstract class User {
  @HiveField(0)
  int id;
  @HiveField(1)
  Map<String,dynamic>? nameData;
  @HiveField(2)
  String? dateOfBrith;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? permission;
  @HiveField(5)
  String? profileImage;
  @HiveField(6)
  List<String>? phones;
  @HiveField(7)
  Map<String,dynamic>? collegeNameData;
  @HiveField(8)
  Section? section;
  @HiveField(9)
  String? createdAt;
  @HiveField(10)
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




