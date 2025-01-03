import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/utils/json_utils.dart';

import 'instructor_model.dart';

class Subject {
  Subject({
    required this.id,
    this.subjectNameData,
    this.units,
    this.descriptionData,
    this.instructors,
  });


  String id;
  Map<String,dynamic>? subjectNameData;
  int? units;
  Map<String,dynamic>? descriptionData;
  Map<int,Instructor>? instructors;

  String? get subjectName {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return subjectNameData?[currentLang];
  }

  String? get description {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return descriptionData?[currentLang];
  }

  factory Subject.fromJson(Map<String, dynamic> json) {

    Map<int,Instructor> instructors = {};
    for(Map<String,dynamic> instructor in (json["doctors"]??{})){
      instructors[instructor["doctor_id"]] = Instructor.fromJson(instructor);
    }
    return Subject(
      id: json['subject_id'],
      subjectNameData: JsonUtils.tryJsonDecode(json['subject_name']),
      units: json['number_of_units'],
      instructors: instructors,
      descriptionData: JsonUtils.tryJsonDecode(json['subject_description']),

    );
  }


  Map<String, dynamic> toJson() {
    return {
      "subject_id": id,
      "subject_name":subjectName,

    };
  }

}
