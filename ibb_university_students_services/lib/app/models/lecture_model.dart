import 'dart:convert';

import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/utils/json_utils.dart';

class Lecture {
  Lecture({
    required this.id,
    this.subjectNameData,
    this.startTime,
    this.duration,
    this.doctorData,
    this.hall,
    this.description,
    this.canceled,
  });

  int id;
  Map<String,dynamic>? subjectNameData;
  String? startTime;
  int? duration;
  Map<String,dynamic>? doctorData;
  String? hall;
  String? description;
  bool? canceled = false;

  String? get doctor {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    print(doctorData);
    return doctorData?[currentLang];
  }

  String? get subjectName {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    print(subjectNameData);
    return subjectNameData?[currentLang];
  }

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
        id: json['id'],
        subjectNameData: JsonUtils.tryJsonDecode(json['subject_name']),
        startTime: json['startTime'],
        duration: json['duration'],
        description: json['description'],
        doctorData: JsonUtils.tryJsonDecode(json['lecturer']),
        hall: json['lecture_room']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject_name":subjectName,
      "startTime": startTime,
      "duration": duration,
      "lecturer": doctor,
      "description":description,
      "lecture_room": hall,
    };
  }

}
