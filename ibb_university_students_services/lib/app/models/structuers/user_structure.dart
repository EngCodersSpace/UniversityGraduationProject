import 'package:get/get_rx/src/rx_types/rx_types.dart';
class User {
  User({
    required this.id,
    this.name,
    this.level,
    this.part,
    this.department,
    this.profileImage,
  });

  RxInt id;
  RxString? name ;
  RxString? level;
  RxString? part;
  RxString? department;
  RxString? profileImage;
}