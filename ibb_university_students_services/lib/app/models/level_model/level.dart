import 'package:hive/hive.dart';
part 'level.g.dart';
@HiveType(typeId: 0)
class Level {
  @HiveField(0)
  int id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? createdAt;
  @HiveField(3)
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
      name: json['level_name'].toString(),
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




