

import 'dart:convert';

import 'package:get/get.dart';

import '../utils/json_utils.dart';

class Section {
  int id;
  Map<String,dynamic>? nameData;
  String? createdAt;
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




