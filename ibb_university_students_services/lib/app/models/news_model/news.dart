import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';
part 'news.g.dart';
@HiveType(typeId: 69)
class Level {
  @HiveField(0)
  int id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? content;
  @HiveField(3)
  String? date;
  @HiveField(4)
  Instructor? publisher;
  @HiveField(5)
  String? createdAt;
  @HiveField(6)
  String? updatedAt;

  Level({
    required this.id,
    this.title,
    this.content,
    this.publisher,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: json['date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "publisher_id": publisher?.toJson(),
      "updatedAt": updatedAt,
      "createdAt": createdAt
    };
  }

}




