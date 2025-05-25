import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/permission_model/permission.dart';
part 'role.g.dart';

@HiveType(typeId: 33)
class Role {
  @HiveField(0)
  int id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? roleType;
  @HiveField(3)
  Map<String, List<Permission>> permissions;
  @HiveField(4)
  String? createdAt;
  @HiveField(5)
  String? updatedAt;
  @HiveField(5)
  String? type;

  Role({
    required this.id,
    required this.permissions,
    this.type,
    this.name,
    this.roleType,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    Map<String, List<Permission>> permissionsMap = {};

    if (json["permissions"] != null && json["permissions"] is List) {
      for (Map<String, dynamic> permission in json["permissions"]) {
        if (permissionsMap[permission['target']] == null) {
          permissionsMap[permission['target']] = [];
        }
        permissionsMap[permission['target']]
            ?.add(Permission.fromJson(permission));
      }
    }

    return Role(
      id: json['id'],
      name: json['roleName'],
      roleType: json['user_type'],
      permissions: permissionsMap,
      type: json['user_type'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "user_type": type,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
