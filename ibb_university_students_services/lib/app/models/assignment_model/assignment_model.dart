import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';
import '../../utils/json_utils.dart';
import '../attachment_file_model/attachment_file_model.dart';
import '../helper_models/student_assignment_state/student_assignment_state.dart';
import '../subject_model/subject_model.dart';

part 'assignment_model.g.dart';

@HiveType(typeId: 15)
class Assignment {
  Assignment({
    required this.id,
    this.subject,
    this.doctor,
    this.titleData,
    this.assignmentDay,
    this.assignmentDate,
    this.dueDate,
    this.attachments,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  Subject? subject;
  @HiveField(2)
  Instructor? doctor;
  @HiveField(3)
  Map<String, dynamic>? titleData;
  @HiveField(4)
  String? assignmentDay;
  @HiveField(5)
  String? assignmentDate;
  @HiveField(6)
  String? dueDate;
  @HiveField(7)
  Map<int, AttachmentFile>? attachments;
  @HiveField(8)
  Map<int, StudentAssignmentState>? studentsStatus;

  String? get title {
    String currentLang = Get.locale?.languageCode.toString() ?? "en";
    return titleData?[currentLang];
  }

  factory Assignment.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    Map<int, AttachmentFile> files = {};
    for (Map<String, dynamic> file in json["assignment_files"] ?? []) {
      files[file["id"]] = AttachmentFile(
          id: file["id"],
          assignmentId: file["assignment_id"],
          title: "title.type",
          path: file["attachment"],
          status: RxString("Not Uploaded"));
    }
    return Assignment(
      id: json['id'],
      subject: subject,
      doctor: Instructor.fromJson({
        "doctor_id": json['doctor_id'],
        "user": {"user_name": "{\"en\":\"Doctor name\",\"ar\":\"اسم الدكتور\"}"}
      }),
      titleData: JsonUtils.tryJsonDecode(
        json['title'],
      ),
      assignmentDay: json['assignment_due_day'],
      assignmentDate: json['assignment_date'],
      dueDate: json['assignments_due_date'],
      attachments: files,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "assignment_id": id,
      "subject": subject?.toJson(),
      "doctor": doctor?.toJson(),
      "title": titleData,
      "assignment_day": assignmentDay,
      "assignment_date": assignmentDate,
      "assignments_due_date": dueDate,
      "attachment": attachments,
    };
  }
}
