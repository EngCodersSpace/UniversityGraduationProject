import 'package:ibb_university_students_services/app/models/subject_model.dart';

class Exam {
  Exam({
    required this.id,
    this.subject,
    this.date,
    this.day,
    this.examTime,
    this.hall,
  });


  int id;
  Subject? subject;
  String? date;
  String? day;
  String? examTime;
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
