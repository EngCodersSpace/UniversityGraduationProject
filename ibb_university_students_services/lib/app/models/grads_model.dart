import 'package:ibb_university_students_services/app/models/subject_model.dart';

class Grad {
  Grad({
    required this.id,
    this.levelId,
    this.term,
    this.yearOfIssue,
    this.subject,
    this.examGrad,
    this.workGrad,
    this.isAbsent,
  });

  int id;
  int? levelId;
  String? term;
  String? yearOfIssue;
  bool? isAbsent;
  Subject? subject;
  int? examGrad;
  int? workGrad;

  factory Grad.fromJson(Map<String, dynamic> json) {
    return Grad(
      id: json['grad_id'],
      levelId: json['level_id'],
      term: json['term'],
      yearOfIssue: json['year_of_issue'],
      subject: Subject.fromJson(json['subject']),
      examGrad: json['exam_grade'],
      workGrad: json['work_grade'],
      isAbsent: json['is_absent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject": subject,
    };
  }
}
