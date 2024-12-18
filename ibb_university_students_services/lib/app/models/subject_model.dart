import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/utils/json_utils.dart';

class Subject {
  Subject({
    required this.id,
    this.subjectNameData,
    this.units,
    this.descriptionData
  });


  String id;
  Map<String,dynamic>? subjectNameData;
  int? units;
  Map<String,dynamic>? descriptionData;

  String? get subjectName {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return subjectNameData?[currentLang];
  }

  String? get description {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return descriptionData?[currentLang];
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['subject_id'],
      subjectNameData: JsonUtils.tryJsonDecode(json['subject_name']),
      units: json['number_of_units'],
      descriptionData: JsonUtils.tryJsonDecode(json['subject_description']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject_name":subjectName,

    };
  }

}
