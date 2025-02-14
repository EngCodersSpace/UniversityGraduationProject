import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/utils/file_utils.dart';

part 'student_assignments_file_model.g.dart';

@HiveType(typeId: 18)
class StudentAssignmentsFile {
  StudentAssignmentsFile({
     required this.id,
    this.studentAssignmentId,
    this.title,
    this.path,
    this.status,
    this.progress
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  int? studentAssignmentId;
  @HiveField(3)
  String? path;
  @HiveField(4)
  String? title;
  RxString? status;
  RxInt? progress;
  final RxBool downloaded = RxBool(false);


  checkDownloaded()async{
    downloaded.value = await FileUtils.checkExists(path??"")??false;
    return;
  }


  factory StudentAssignmentsFile.fromJson(Map<String, dynamic> json, {String status = "Not Uploaded"}) {

    return StudentAssignmentsFile(
      id: json['id'],
      studentAssignmentId: json["student_assignment_id"],
      path: json["path"],
      status: RxString(status),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }
}
