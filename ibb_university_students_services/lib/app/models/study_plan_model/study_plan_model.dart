import 'package:hive/hive.dart';
part 'study_plan_model.g.dart';

@HiveType(typeId: 12)
class StudyPlan {
  @HiveField(0)
  int id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  List<int>? studyPlaneElement;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  String? updatedAt;

  StudyPlan({
    required this.id,
    this.name,
    this.studyPlaneElement,
    this.createdAt,
    this.updatedAt,
  });

  factory StudyPlan.fromJson(Map<String, dynamic> json) {
    return StudyPlan(
      id: json['study_plan_id'],
      studyPlaneElement: [],
      name: json['study_plan_name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
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
