import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ibb_university_students_services/app/models/lavel_model.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

class Student extends User {
  int? studyPlaneId;
  Level? level;
  Section? section;
  String? system;
  String? enrollmentYear;

  Student({
    required super.id,
    super.name,
    super.dateOfBrith,
    super.email,
    super.phones,
    super.profileImage,
    super.permission,
    this.studyPlaneId,
    this.level,
    this.section,
    this.system,
    this.enrollmentYear,
    super.createdAt,
    super.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      dateOfBrith: json['date_of_brith'],
      email: json['email'],
      permission: json['permission'],
      phones: json['phones'],
      profileImage: json['profile_image'],
      studyPlaneId: json['study_plan_id'],
      level: json['student_level'],
      section: json['student_section'],
      system: json['student_system'],
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
      "student_system": system,
      "enrollment_year": enrollmentYear,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
