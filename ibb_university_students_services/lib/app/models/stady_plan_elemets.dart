
class StudyPlanElement {
  int id;
  // int studyPlanId;
  // int subjectId;
  // int doctorId;
  String? name;
  String? createdAt;
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




