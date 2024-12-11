import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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
    Map<String,dynamic>? subjectNameDataJs = {};
    Map<String,dynamic>? doctorDataJs = {};
    try{
       subjectNameDataJs = jsonDecode(json['subject_name']);
       doctorDataJs = jsonDecode(json['lecturer']);
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    return Lecture(
        id: json['id'],
        subjectNameData: subjectNameDataJs,
        startTime: json['startTime'],
        duration: json['duration'],
        description: json['description'],
        doctorData: doctorDataJs,
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
