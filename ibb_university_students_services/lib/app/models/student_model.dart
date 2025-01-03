import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/level_model.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

import '../utils/json_utils.dart';

class Student extends User {
  int? studyPlaneId;
  Level? level;
  Map<String,dynamic>? systemData;
  String? enrollmentYear;

  String? get system {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return systemData?[currentLang];
  }

  Student({
    required super.id,
    super.nameData,
    super.dateOfBrith,
    super.email,
    super.phones,
    super.profileImage,
    super.permission,
    this.studyPlaneId,
    this.level,
    super.collegeNameData,
    super.section,
    this.systemData,
    this.enrollmentYear,
    super.createdAt,
    super.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['user_id'],
      nameData: JsonUtils.tryJsonDecode(json['user_name']),
      dateOfBrith: json['date_of_brith'],
      email: json['email'],
      permission: json['permission'],
      phones: json['phones'],
      // profileImage: json['profile_picture'],
      studyPlaneId: json['study_plan_id'],
      level: Level.fromJson(json["level"]),
      collegeNameData: JsonUtils.tryJsonDecode(json['collegeName']),
      section: Section.fromJson(json["section"]),
      systemData: JsonUtils.tryJsonDecode(json['student_system']),
      enrollmentYear: json['enrollment_year'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "date_of_brith": dateOfBrith,
      "email": email,
      "permission": permission,
      "profile_image": profileImage,
      "phones": phones,
      "study_plan_id": studyPlaneId,
      "student_level": level,
      "student_section": section,
      "student_system": systemData,
      "enrollment_year": enrollmentYear,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
