import 'package:ibb_university_students_services/app/models/subject_model.dart';

class Lecture {
  Lecture({
    required this.id,
    this.subject,
    this.startTime,
    this.duration,
    this.instructorId,
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
  int? instructorId;

  factory Lecture.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    return Lecture(
      id: json['id'],
      lectureStatus: json["lectureStatus"],
      subject: subject,
      startTime: json['lecture_time'],
      duration: json['lecture_duration'],
      description: json['description'],
      instructorId: json["doctor_id"],
      hall: json['lecture_room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject": subject?.toJson(),
      "lecture_time": startTime,
      "duration": duration,
      "doctor_id": instructorId,
      "description": description,
      "lectureStatus": lectureStatus,
      "lecture_room": hall,
    };
  }

  void updateFromJson(Map<String, dynamic> json, {Subject? subject}) {
    id = json['id'] ?? id;
    lectureStatus = json["lectureStatus"] ?? lectureStatus;
    this.subject = subject ?? this.subject;
    startTime = json['lecture_time'] ?? startTime;
    duration = json['lecture_duration'] ?? duration;
    description = json['description'] ?? description;
    instructorId = json["doctor_id"] ?? instructorId;
    hall = json['lecture_room'] ?? hall;
  }
}
