import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/utils/json_utils.dart';

import '../instructor_model/instructor_model.dart';

part 'subject_model.g.dart';

@HiveType(typeId: 5)
class Subject {
  Subject({
    required this.id,
    this.subjectNameData,
    this.units,
    this.descriptionData,
    this.instructors,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  Map<String,dynamic>? subjectNameData;
  @HiveField(2)
  int? units;
  @HiveField(3)
  Map<String,dynamic>? descriptionData;
  @HiveField(4)
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
