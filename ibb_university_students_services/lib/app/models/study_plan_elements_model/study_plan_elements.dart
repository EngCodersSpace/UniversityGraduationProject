import 'package:hive/hive.dart';
part 'study_plan_elements.g.dart';
@HiveType(typeId: 10)
class StudyPlanElement {
  @HiveField(0)
  int id;
  // int studyPlanId;
  // int subjectId;
  // int doctorId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? createdAt;
  @HiveField(3)
  String? updatedAt;

  StudyPlanElement({
    required this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory StudyPlanElement.fromJson(Map<String, dynamic> json) {
    return StudyPlanElement(
      id: json['id'],
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




