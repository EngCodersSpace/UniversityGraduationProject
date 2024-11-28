import 'package:get/get_rx/src/rx_types/rx_types.dart';

class StudyPlane {
  int id;
  String? name;
  List<String>? phones;
  String? createdAt;
  String? updatedAt;

  StudyPlane({
    required this.id,
    this.name,
    this.phones,
    this.createdAt,
    this.updatedAt,
  });

  factory StudyPlane.fromJson(Map<String, dynamic> json) {
    return StudyPlane(
      id: json['id'],
      name: json['name'],
      phones: json['phones'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phones": phones,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

}




