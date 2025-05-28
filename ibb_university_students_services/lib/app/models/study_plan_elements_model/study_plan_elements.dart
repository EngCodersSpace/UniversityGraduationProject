import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';
part 'study_plan_elements.g.dart';
@HiveType(typeId: 10)
class StudyPlanElement {
  @HiveField(0)
  int id;
  @HiveField(1)
  int? studyPlanId;
  @HiveField(2)
  int? subjectId;
  @HiveField(3)
  int? sectionId;
  @HiveField(4)
  int? levelId;
  @HiveField(5)
  Instructor? doctor;
  @HiveField(6)
  String? name;
  @HiveField(7)
  String? createdAt;
  @HiveField(8)
  String? updatedAt;

  StudyPlanElement({
    required this.id,
    this.studyPlanId,
    this.sectionId,
    this.levelId,
    this.subjectId,
    this.doctor,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory StudyPlanElement.fromJson(Map<String, dynamic> json) {
    return StudyPlanElement(
      id: json['id'],
      studyPlanId: json['study_plan_id'],
      sectionId: json['section_id'],
      levelId: json['level_id'],
      subjectId: json['subject_id'],
      doctor: json['doctor'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

}




