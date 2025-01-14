import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Section {
  int id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Section({
    required this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
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




