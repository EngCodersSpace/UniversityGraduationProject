import 'package:get/get.dart';
import '../utils/json_utils.dart';

class Instructor {
  int id;
  Map<String,dynamic>? nameData;
  Instructor({
    required this.id,
    this.nameData,
  });

  String? get name {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return nameData?[currentLang];
  }
  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['doctor_id'],
      nameData: JsonUtils.tryJsonDecode(json['user']['user_name']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
    "doctor_id": id,
      "user":{"user_name":nameData}

  };
  }
}




