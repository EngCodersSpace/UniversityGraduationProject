import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';

import '../../utils/json_utils.dart';
part 'news.g.dart';
@HiveType(typeId: 69)
class News {
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

  News({
    required this.id,
    this.title,
    this.content,
    this.publisher,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: json['time'],
      publisher: Instructor(id:json['publisher']['user_id'] ,nameData: JsonUtils.tryJsonDecode(json['publisher']['user_name'])),
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




