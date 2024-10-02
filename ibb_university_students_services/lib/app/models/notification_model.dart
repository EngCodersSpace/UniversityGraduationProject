import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Notification {
  RxInt id;
  RxString? author;
  RxString? time;
  RxString? message;
  RxString? date;
  RxString? createdAt;
  RxString? updatedAt;

  Notification({
    required this.id,
    this.author,
    this.time,
    this.message,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: RxInt(json['id'] ?? 0),
      author: RxString(json['author'] ?? ""),
      time: RxString(json['time'] ?? ""),
      message: RxString(json['message'] ?? ""),
      date: RxString(json['date'] ?? ""),
      createdAt: RxString(json['created_at'] ?? ""),
      updatedAt: RxString(json['updated_at'] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "author": author?.value,
      "time": time?.value,
      "message": message?.value,
      "date": date?.value,
      "created_at": createdAt?.value,
      "updated_at": updatedAt?.value,
    };
  }
}
