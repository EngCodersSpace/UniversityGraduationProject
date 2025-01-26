import 'package:hive/hive.dart';
import '../subject_model/subject_model.dart';

part 'attachment_file_model.g.dart';

@HiveType(typeId: 16)
class AttachmentFile {
  AttachmentFile({
    this.id,
    this.assignmentId,
    this.path,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  int? assignmentId;
  @HiveField(2)
  String? path;
  @HiveField(3)
  String? status;


  factory AttachmentFile.fromJson(Map<String, dynamic> json, {Subject? subject}) {
    return AttachmentFile(
      id: json['id'],
      assignmentId: 0,
      path: "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }
}
