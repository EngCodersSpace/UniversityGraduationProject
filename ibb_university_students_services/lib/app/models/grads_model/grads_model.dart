

import 'package:hive/hive.dart';

import '../subject_model/subject_model.dart';
part 'grads_model.g.dart';

@HiveType(typeId: 9)
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
    this.sectionId,
    this.studentId,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  int? levelId;
  @HiveField(2)
  String? term;
  @HiveField(3)
  String? yearOfIssue;
  @HiveField(4)
  bool? isAbsent;
  @HiveField(5)
  Subject? subject;
  @HiveField(6)
  int? examGrad;
  @HiveField(7)
  int? workGrad;
  @HiveField(8)
  int? sectionId;
  @HiveField(9)
  int? studentId;

  factory Grad.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    return Grad(
      id: json['grad_id'],
      levelId: json['level_id'],
      term: json['term'],
      yearOfIssue: json['year_of_issue'],
      subject: Subject.fromJson(json["subject"]),
      examGrad: json['exam_grade'],
      workGrad: json['work_grade'],
      isAbsent: json['is_absent'],
      sectionId: json['section_id'],
      studentId: json['student_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject": subject,
    };
  }
}
