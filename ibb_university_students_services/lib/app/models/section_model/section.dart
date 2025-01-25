import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../utils/json_utils.dart';
part 'section.g.dart';
@HiveType(typeId: 1)
class Section {
  @HiveField(0)
  int id;
  @HiveField(1)
  Map<String,dynamic>? nameData;
  @HiveField(2)
  String? createdAt;
  @HiveField(3)
  String? updatedAt;

  Section({
    required this.id,
    this.nameData,
    this.createdAt,
    this.updatedAt,
  });

  String? get name{
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return nameData?[currentLang];
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      nameData: JsonUtils.tryJsonDecode(json['section_name']),
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




