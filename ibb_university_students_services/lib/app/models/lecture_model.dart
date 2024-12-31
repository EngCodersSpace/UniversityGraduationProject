import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/instructor_model.dart';
import 'package:ibb_university_students_services/app/models/subject_model.dart';
import 'package:ibb_university_students_services/app/utils/json_utils.dart';

class Lecture {
  Lecture({
    required this.id,
    this.subject,
    this.startTime,
    this.duration,
    this.instructor,
    this.hall,
    this.description,
    this.lectureStatus,
  });

  int id;
  Subject? subject;
  String? startTime;
  int? duration;
  String? hall;
  String? description;
  bool? lectureStatus = false;
  Instructor? instructor;


  factory Lecture.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    return Lecture(
        id: json['id'],
        lectureStatus: json["lectureStatus"],
        subject: subject,
        startTime: json['startTime'],
        duration: json['lecture_duration'],
        // description: json['description'],
      instructor: Instructor.fromJson(json["instructor"]),
        hall: json['lecture_room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject":subject?.toJson(),
      "startTime": startTime,
      "duration": duration,
      "instructor": instructor?.toJson(),
      "description":description,
      "lecture_room": hall,
    };
  }

}
