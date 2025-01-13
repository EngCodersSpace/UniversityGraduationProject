import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
part 'notification_model.g.dart';
@HiveType(typeId: 9)
class Notification {
  @HiveField(0)
  RxInt id;
  @HiveField(1)
  RxString? author;
  @HiveField(2)
  RxString? time;
  @HiveField(3)
  RxString? message;
  @HiveField(4)
  RxString? date;
  @HiveField(5)
  RxBool? readState;
  @HiveField(6)
  RxString? createdAt;
  @HiveField(7)
  RxString? updatedAt;

  Notification({
    required this.id,
    this.author,
    this.time,
    this.message,
    this.date,
    this.readState,
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
      readState: RxBool(json['readState']),
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
      "readState": readState?.value,
      "created_at": createdAt?.value,
      "updated_at": updatedAt?.value,
    };
  }
}
