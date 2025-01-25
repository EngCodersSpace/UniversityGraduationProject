import 'package:hive/hive.dart';
part 'study_plan_model.g.dart';

@HiveType(typeId: 12)
class StudyPlane {
  @HiveField(0)
  int id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? createdAt;
  @HiveField(3)
  String? updatedAt;

  StudyPlane({
    required this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory StudyPlane.fromJson(Map<String, dynamic> json) {
    return StudyPlane(
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




