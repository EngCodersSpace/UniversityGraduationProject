
class StudyPlane {
  int id;
  String? name;
  String? createdAt;
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




