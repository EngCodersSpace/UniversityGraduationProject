import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../attachment_file_model/attachment_file_model.dart';
part 'student_assignment_state.g.dart';

@HiveType(typeId: 17)
class StudentAssignmentState{

  StudentAssignmentState({
    this.studentId,
    this.studentNameData,
    this.state,
    this.isCompleted,
    this.studentFiles,
  });

  @HiveField(0)
  int? studentId;
  @HiveField(1)
  Map<String, dynamic>? studentNameData;
  @HiveField(3)
  String? state;
  @HiveField(4)
  bool? isCompleted ;
  @HiveField(5)
  List<AttachmentFile>? studentFiles;

  String? get studentName {
    String currentLang = Get.locale?.languageCode.toString() ?? "en";
    return studentNameData?[currentLang];
  }

  factory StudentAssignmentState.fromJson(Map<String, dynamic> json) {
    List<AttachmentFile> files = [];
    for(Map<String,dynamic> file in json["student_assignment_files"]){
      files.add(AttachmentFile.fromJson(file));
    }
    return StudentAssignmentState(
      studentId: json['student_id'],
      // studentNameData: JsonUtils.tryJsonDecode(
      //   json['title'],
      // ),
      state: json['status'],
      isCompleted: json['is_completed'],
      studentFiles: files,
    );
  }

  Map<String, dynamic> toJson() {
    return {

    };
  }

}




