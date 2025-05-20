import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import '../../utils/file_utils.dart';
import '../subject_model/subject_model.dart';

part 'library_files_model.g.dart';

@HiveType(typeId: 19)
class LibraryFile {
  LibraryFile({
    required this.id,
    this.levelId,
    this.sectionId,
    required this.category,
    this.subject,
    this.addedBy,
    this.title,
    this.filePath,
    this.fileSize,
    this.author,
    this.edition,
    this.displayImage,
    this.numberOfPages,
    this.originalName,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  int? sectionId;

  @HiveField(2)
  int? levelId;

  @HiveField(3)
  Subject? subject;

  @HiveField(4)
  int? addedBy;

  @HiveField(5)
  String? title;

  @HiveField(6)
  String? author;

  @HiveField(7)
  int? numberOfPages;

  @HiveField(8)
  String? edition;

  @HiveField(9)
  String category;

  @HiveField(10)
  double? fileSize;

  @HiveField(11)
  String? filePath;

  @HiveField(12)
  String? displayImage;

  @HiveField(13)
  String? originalName;

  RxString? status;
  RxInt? progress;
  final RxBool downloaded = RxBool(false);


  checkDownloaded()async{
    downloaded.value = await FileUtils.checkExists(filePath??"")??false;
    return;
  }


  factory LibraryFile.fromJson(Map<String, dynamic> json, {Subject? subject}) {


    return LibraryFile(
      id: json['id'],
      sectionId: json['section_id'],
      levelId: json['level_id'],
      subject: subject,
      title: json['title'],
      author: json['author'],
      numberOfPages: json['numberOfPages'],
      addedBy: json['added_by'],
      filePath: json['file_path'],
      fileSize: json['file_size'].toDouble(),
      edition: json['edition'],
      category: json['category'],
      displayImage: json['display_image'],
    );
  }

  void updateFromJson(Map<String, dynamic> json, {Subject? subject}) {

    sectionId = json["section_id"] ?? sectionId;
    levelId = json["level_id"] ?? levelId;
    this.subject = subject ?? this.subject;
  }

  Map<String, dynamic> toJson() {
    return {
      "assignment_id": id,
      "subject": subject?.toJson(),
    };
  }
}
