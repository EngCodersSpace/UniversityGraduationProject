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
    this.levelId,
    this.sectionId,
    this.subject,
    this.doctor,
    this.titleData,
    this.assignmentDay,
    this.assignmentDate,
    this.dueDate,
    this.attachments,
    this.studentsStatus,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  int? sectionId;
  @HiveField(2)
  int? levelId;
  Subject? subject;
  @HiveField(3)
  Instructor? doctor;
  @HiveField(4)
  Map<String, dynamic>? titleData;
  @HiveField(5)
  String? assignmentDay;
  @HiveField(6)
  String? assignmentDate;
  @HiveField(7)
  String? dueDate;
  @HiveField(8)
  Map<int, AttachmentFile>? attachments;
  @HiveField(9)
  Map<int, StudentAssignmentState>? studentsStatus;

  String? get title {
    String currentLang = Get.locale?.languageCode.toString() ?? "en";
    return titleData?[currentLang];
  }

  factory Assignment.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    Map<int, AttachmentFile> files = {};
    for (Map<String, dynamic> file in json["assignment_files"] ?? []) {
      files[file["id"]] = AttachmentFile.fromJson(file,status: "Uploaded");
    }
    StudentAssignmentState? state;
    if (json['student_assignments'] != null) {
      state = StudentAssignmentState.fromJson(json['student_assignments'][0]);
    }

    return Assignment(
      id: json['id'],
      sectionId: json['section_id'],
      levelId: json['level_id'],
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
      studentsStatus: (state != null) ? {state.id!: state} : null,
    );
  }




  void updateFromJson(Map<String, dynamic> json,{Subject? subject}){

    Map<int, AttachmentFile> files = {};
    for (Map<String, dynamic> file in json["assignment_files"] ?? []) {
      files[file["id"]] = AttachmentFile(
          id: file["id"],
          assignmentId: file["assignment_id"],
          originName: "title.type",
          path: file["attachment"],
          status: RxString("Not Uploaded"));
    }
    StudentAssignmentState? state;
    if (json['student_assignments'] != null) {
      state = StudentAssignmentState.fromJson(json['student_assignments'][0]);
    }

    sectionId = json["section_id"]??sectionId;
    levelId = json["level_id"]??levelId;
    this.subject = subject??this.subject;
    doctor = json['doctor']??doctor;
    titleData = JsonUtils.tryJsonDecode(
      json['title'],
    )??titleData;
    assignmentDay = json['assignment_due_day']??assignmentDay;
    assignmentDate = json['assignment_date']??assignmentDate;
    dueDate = json['assignments_due_date']??dueDate;
    studentsStatus = (state != null) ? {state.id!: state} : studentsStatus;
    attachments = ((files.isNotEmpty))?files:attachments;
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
      "studentsStatus":studentsStatus

    };
  }
}
