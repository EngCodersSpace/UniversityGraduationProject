import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Level {
  int id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Level({
    required this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
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




