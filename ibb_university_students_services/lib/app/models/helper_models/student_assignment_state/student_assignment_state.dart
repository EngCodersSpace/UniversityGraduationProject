import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/student_assignments_file_model/student_assignments_file_model.dart';
import '../../../utils/json_utils.dart';
part 'student_assignment_state.g.dart';

@HiveType(typeId: 17)
class StudentAssignmentState{

  StudentAssignmentState({
    this.id,
    this.studentId,
    this.studentNameData,
    this.state,
    this.isCompleted,
    this.studentFiles,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  int? studentId;
  @HiveField(2)
  Map<String, dynamic>? studentNameData;
  @HiveField(3)
  String? state;
  @HiveField(4)
  bool? isCompleted ;
  @HiveField(5)
  Map<int,StudentAssignmentsFile>? studentFiles;

  String? get studentName {
    String currentLang = Get.locale?.languageCode.toString() ?? "en";
    return studentNameData?[currentLang];
  }

  factory StudentAssignmentState.fromJson(Map<String, dynamic> json) {
    Map<int,StudentAssignmentsFile> files = {};
    for(Map<String,dynamic> file in json["student_assignment_files"]){
      files[json["id"]] = StudentAssignmentsFile.fromJson(file);
    }
    return StudentAssignmentState(
      id: json["id"],
      studentId: json['student']['student_id'],
      studentNameData: JsonUtils.tryJsonDecode(
        json['student']['user']['user_name'],
      ),
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




