import 'package:ibb_university_students_services/app/models/section_model.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

class Doctor extends User {
  Section? section;
  String? status;
  String? academicDegree;
  String? administrativePosition;

  Doctor({
    required super.id,
    super.name,
    super.dateOfBrith,
    super.email,
    super.phones,
    super.profileImage,
    super.permission,
    this.section,
    this.status,
    this.administrativePosition,
    this.academicDegree,
    super.createdAt,
    super.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      dateOfBrith: json['date_of_brith'],
      email: json['email'],
      permission: json['permission'],
      phones: json['phones'],
      profileImage: json['profile_image'],
      section: json['section'],
      academicDegree: json['academic_degree'],
      administrativePosition: json['administrative_position'],
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
