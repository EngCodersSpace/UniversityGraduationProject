import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';
part 'notification_model.g.dart';
@HiveType(typeId: 91)
class Notification {
  @HiveField(0)
  int id;
  @HiveField(1)
  Instructor? sender;
  @HiveField(2)
  Instructor? receiver;
  @HiveField(3)
  String? topicName;
  @HiveField(4)
  String? title;
  @HiveField(5)
  String? message;
  @HiveField(6)
  String? createdAt;
  @HiveField(7)
  String? updatedAt;

  Notification({
    required this.id,
    this.sender,
    this.receiver,
    this.topicName,
    this.title,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      sender: (json['senderUser']!=null)?Instructor.fromJson(json['senderUser']):null,
      receiver: (json['receiverUser']!=null)?Instructor.fromJson(json['receiverUser']):null,
      topicName: json['topic_name'],
      title: json['title'],
      message: json['message'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message_id": id,
      "senderUser": sender?.toJson(),
      "receiverUser":receiver?.toJson(),
      "topic_name": topicName,
      "title": title,
      "message": message,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
