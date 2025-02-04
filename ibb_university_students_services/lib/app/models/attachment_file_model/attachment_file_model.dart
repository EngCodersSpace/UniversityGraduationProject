import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/utils/file_utils.dart';

part 'attachment_file_model.g.dart';

@HiveType(typeId: 16)
class AttachmentFile {
  AttachmentFile({
     required this.id,
    this.assignmentId,
    this.title,
    this.path,
    this.status,
    this.progress
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  int? assignmentId;
  @HiveField(3)
  String? path;
  @HiveField(4)
  String? title;
  RxString? status;
  RxInt? progress;
  final RxBool downloaded = RxBool(false);


  checkDownloaded()async{
    downloaded.value = await FileUtils.checkExists(subPath: "/UploadedFiles",path??"")??false;
    return;
  }


  factory AttachmentFile.fromJson(Map<String, dynamic> json, {String status = "Not Uploaded"}) {

    return AttachmentFile(
      id: json['id'],
      assignmentId: 0,
      path: "",
      status: RxString(status),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }
}
