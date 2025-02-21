import 'package:get/get.dart';
import 'package:hive/hive.dart';
part 'role.g.dart';
@HiveType(typeId: 33)
class Role {
  @HiveField(0)
  int id;
  @HiveField(1)
  Map<String,dynamic>? nameData;
  @HiveField(2)
  Map<String,List<String>> permissions;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  String? updatedAt;

  Role({
    required this.id,
    required this.permissions,
    this.nameData,
    this.createdAt,
    this.updatedAt,
  });

  String? get name{
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return nameData?[currentLang];
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      // nameData: JsonUtils.tryJsonDecode(json['role_name']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      permissions: {},
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




