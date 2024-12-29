import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/subject_model.dart';
import 'package:ibb_university_students_services/app/utils/json_utils.dart';

class Lecture {
  Lecture({
    required this.id,
    this.subject,
    this.startTime,
    this.duration,
    this.doctorData,
    this.hall,
    this.description,
    this.canceled,
  });

  int id;
  Subject? subject;
  String? startTime;
  int? duration;
  Map<String,dynamic>? doctorData;
  String? hall;
  String? description;
  bool? canceled = false;

  String? get doctor {
    String currentLang = Get.locale?.languageCode.toString()??"en";
    return doctorData?[currentLang];
  }


  factory Lecture.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    print("here ${json}");
    return Lecture(
        id: json['id'],
        subject: subject,
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
      "subject":subject?.toJson(),
      "startTime": startTime,
      "duration": duration,
      "lecturer": doctor,
      "description":description,
      "lecture_room": hall,
    };
  }

}
