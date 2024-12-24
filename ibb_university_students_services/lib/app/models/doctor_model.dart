import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

import '../utils/json_utils.dart';

class Doctor extends User {
  String? status;
  Map<String,dynamic>? academicDegreeData;
  Map<String,dynamic>? administrativePositionData;

  Doctor({
    required super.id,
    super.nameData,
    super.dateOfBrith,
    super.email,
    super.phones,
    super.profileImage,
    super.permission,
    super.section,
    this.status,
    this.administrativePositionData,
    this.academicDegreeData,
    super.createdAt,
    super.updatedAt,
  });

  String? get administrativePosition{
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return administrativePositionData?[currentLang];
  }
  String? get academicDegree{
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return academicDegreeData?[currentLang];
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['user_id'],
      nameData: JsonUtils.tryJsonDecode(json['user_name']),
      dateOfBrith: json['date_of_brith'],
      email: json['email'],
      permission: json['permission'],
      phones: json['phones'],
      // profileImage: json['profile_picture'],
      section: Section.fromJson(json['section']),
      academicDegreeData: JsonUtils.tryJsonDecode(json['academic_degree']),
      administrativePositionData: JsonUtils.tryJsonDecode(json['administrative_position']),
      status: json['status'],
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
      "student_section": section,
      "status": status,
      "section": section,
      "academic_degree":academicDegree,
      "administrative_position":administrativePosition,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
