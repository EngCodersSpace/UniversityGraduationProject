import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/study_plan_model/study_plan_model.dart';
import 'package:ibb_university_students_services/app/models/user_model/user.dart';
import '../../utils/json_utils.dart';
import '../role_model/role.dart';
import '../section_model/section.dart';

part 'student.g.dart';

@HiveType(typeId: 3)
class Student extends User {
  @HiveField(11)
  StudyPlan? studyPlane;
  @HiveField(12)
  Level? level;
  @HiveField(13)
  Map<String, dynamic>? systemData;
  @HiveField(14)
  String? enrollmentYear;
  @HiveField(15)
  int? repeatYearsCount;
  @HiveField(16)
  int? assignmentCount;
  @HiveField(17)
  int? completeAssignmentCount;


  String? get system {
    String currentLang = Get.locale?.languageCode.toString() ?? "en";
    return systemData?[currentLang];
  }

  Student({
    required super.id,
    super.nameData,
    super.dateOfBrith,
    super.email,
    super.phones,
    super.profileImage,
    super.role,
    this.studyPlane,
    this.level,
    super.collegeNameData,
    super.section,
    this.systemData,
    this.enrollmentYear,
    this.repeatYearsCount,
    this.assignmentCount,
    this.completeAssignmentCount,
    super.createdAt,
    super.updatedAt,
  });

  factory Student.fromJson(
    Map<String, dynamic> json,
  ) {
    List<String> numbers = [];

    if (json['phone_numbers'] != null && json['phone_numbers'] is List) {
      for (var item in json['phone_numbers']) {
        if (item is Map && item.containsKey("phone_number")) {
          numbers.add(item["phone_number"]);
        }
      }
    }
    return Student(
      id: json['user_id'] ?? ["student_id"],
      nameData: JsonUtils.tryJsonDecode(json['user_name']),
      dateOfBrith: json['date_of_birth'],
      email: json['email'],
      role: Role.fromJson(json['role']),
      phones: numbers,
      profileImage: json['profile_picture'],
      studyPlane: StudyPlan.fromJson(json['study_plan']),
      level: Level.fromJson(json["level"]),
      collegeNameData: JsonUtils.tryJsonDecode(json['collegeName']),
      section: Section.fromJson(json["section"]),
      systemData: JsonUtils.tryJsonDecode(json['student_system']),
      enrollmentYear: json['enrollment_year'],
      repeatYearsCount: json['repeat_years_count'],
      assignmentCount: json['totalAssignmentsCount'],
      completeAssignmentCount: json['completedAssignmentsCount'],
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
      "role": role?.toJson(),
      "profile_image": profileImage,
      "phones": phones,
      "study_plan_id": studyPlane,
      "student_level": level,
      "student_section": section,
      "student_system": systemData,
      "enrollment_year": enrollmentYear,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
