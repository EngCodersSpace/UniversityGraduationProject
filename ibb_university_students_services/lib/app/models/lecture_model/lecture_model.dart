import 'package:hive/hive.dart';

import '../subject_model/subject_model.dart';

part 'lecture_model.g.dart';

@HiveType(typeId: 8)
class Lecture {
  Lecture({
    required this.id,
    this.sectionId,
    this.day,
    this.levelId,
    this.subject,
    this.startTime,
    this.duration,
    this.instructorId,
    this.hall,
    this.description,
    this.lectureStatus,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  int? sectionId;
  @HiveField(2)
  int? levelId;
  @HiveField(3)
  String? day;
  @HiveField(4)
  Subject? subject;
  @HiveField(5)
  String? startTime;
  @HiveField(6)
  int? duration;
  @HiveField(7)
  String? hall;
  @HiveField(8)
  String? description;
  @HiveField(9)
  bool? lectureStatus = false;
  @HiveField(10)
  int? instructorId;

  factory Lecture.fromJson(Map<String, dynamic> json, {Subject? subject}){
    return Lecture(
      id: json['id'],
      sectionId: json['section_id'],
      levelId: json['level_id'],
      day: json['day'],
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
