import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
part 'study_plan_elements.g.dart';
@HiveType(typeId: 10)
class StudyPlanElement {
  @HiveField(0)
  int id;
  @HiveField(1)
  int? studyPlanId;
  @HiveField(2)
  Subject? subject;
  @HiveField(3)
  int? sectionId;
  @HiveField(4)
  int? levelId;
  @HiveField(5)
  String? term;
  @HiveField(6)
  int? doctorId;
  @HiveField(7)
  String? createdAt;
  @HiveField(8)
  String? updatedAt;

  StudyPlanElement({
    required this.id,
    this.studyPlanId,
    this.sectionId,
    this.levelId,
    this.term,
    this.subject,
    this.doctorId,
    this.createdAt,
    this.updatedAt,
  });

  factory StudyPlanElement.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    return StudyPlanElement(
      id: json['study_plan_elment_id'],
      studyPlanId: json['study_plan_id'],
      sectionId: json['section_id'],
      term: json["term"],
      levelId: json['level_id'],
      subject: subject,
      doctorId: json['doctor_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "studyPlaneId":studyPlanId,
      "sectionId":sectionId,
      "levelId":levelId,
      "term":term,
      "subject":subject?.toJson(),
      "doctorId":doctorId,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

}




