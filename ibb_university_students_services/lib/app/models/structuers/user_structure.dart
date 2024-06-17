import 'package:get/get_rx/src/rx_types/rx_types.dart';
class User {
  RxInt id;
  RxString? name ;
  RxString? email ;
  RxString? phone;
  RxString? level;
  RxString? department;
  RxString? division;
  RxString? profileImage;

  User({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.level,
    this.department,
    this.division,
    this.profileImage,
  });


}