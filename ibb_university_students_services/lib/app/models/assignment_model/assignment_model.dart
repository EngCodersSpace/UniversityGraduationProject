import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';
import '../subject_model/subject_model.dart';
part 'assignment_model.g.dart';
@HiveType(typeId: 15)
class Assignment {
  Assignment({
    required this.id,
    this.subject,
    this.doctor,
    this.title,
    this.assignmentDay,
    this.assignmentDate,
    this.dueDate,
    this.attachment,
  });
  @HiveField(0)
  int id;
  @HiveField(1)
  Subject? subject;
  @HiveField(2)
  Instructor? doctor;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String? assignmentDay;
  @HiveField(5)
  String? assignmentDate;
  @HiveField(6)
  String? dueDate;
  @HiveField(7)
  String? attachment;

  factory Assignment.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    print(json);
    return Assignment(
      id: json['id'],
      subject: subject,
      doctor: Instructor.fromJson({
        "doctor_id": json['doctor_id'],
        "user": {"user_name": "{\"en\":\"Doctor name\",\"ar\":\"اسم الدكتور\"}"}
      }),
      title: json['title'],
      assignmentDay: json['assignment_due_day'],
      assignmentDate: json['assignment_date'],
      dueDate: json['assignments_due_date'],
      // attachment: json['attachment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "assignment_id": id,
      "subject": subject?.toJson(),
      "doctor": doctor?.toJson(),
      "title": title,
      "assignment_day": assignmentDay,
      "assignment_date": assignmentDate,
      "assignments_due_date": dueDate,
      "attachment": attachment,
    };
  }
}
