import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

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
    Map<String,dynamic>? administrativePositionDataJs = {};
    Map<String,dynamic>? academicDegreeDataJs = {};
    Map<String,dynamic>? nameDataJs = {};
    try{
      administrativePositionDataJs = jsonDecode(json['administrative_position']);
      academicDegreeDataJs = jsonDecode(json['academic_degree']);
      nameDataJs = jsonDecode(json['user_name']);
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    return Doctor(
      id: json['user_id'],
      nameData: nameDataJs,
      dateOfBrith: json['date_of_brith'],
      email: json['email'],
      permission: json['permission'],
      phones: json['phones'],
      // profileImage: json['profile_picture'],
      section: Section.fromJson(json['section']),
      academicDegreeData: academicDegreeDataJs,
      administrativePositionData: administrativePositionDataJs,
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
