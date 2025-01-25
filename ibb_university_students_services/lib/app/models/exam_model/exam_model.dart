

import 'package:hive/hive.dart';

import '../subject_model/subject_model.dart';
part 'exam_model.g.dart';
@HiveType(typeId: 6)
class Exam {
  Exam({
    required this.id,
    this.subject,
    this.date,
    this.day,
    this.examTime,
    this.hall,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  Subject? subject;
  @HiveField(2)
  String? date;
  @HiveField(3)
  String? day;
  @HiveField(4)
  String? examTime;
  @HiveField(5)
  String? hall;


  factory Exam.fromJson(Map<String, dynamic> json,{Subject? subject}) {
    return Exam(
        id: json['exam_id'],
        subject: subject,
        date: json['exam_date'],
        day: json['exam_day'],
        examTime: json['exam_time'],
        hall: json['exam_room']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "exam_id": id,
      "subject":subject?.toJson(),
      "exam_date": date,
      "exam_day": day,
      "exam_time": examTime,
      "exam_room": hall,
    };
  }

}
