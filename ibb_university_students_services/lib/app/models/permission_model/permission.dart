import 'package:hive/hive.dart';
part 'permission.g.dart';
@HiveType(typeId: 34)
class Permission {
  @HiveField(0)
  int id;
  @HiveField(1)
  String? target;
  @HiveField(2)
  String? action;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  String? updatedAt;

  Permission({
    required this.id,
    this.target,
    this.action,
    this.createdAt,
    this.updatedAt,
  });


  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      target: json['target'],
      action: json['action'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "target": target,
      "action":action,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

}




