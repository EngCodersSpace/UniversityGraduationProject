import 'package:get/get_rx/src/rx_types/rx_types.dart';

class UserModel {


  static User fetchUser() {
    Map jsData = {
      'id': 2070093,
      'name': 'Shehab AL-Saidi',
      'level': '4th',
      'part': 'Electrical engineering',
      'department': 'Computer engineering',
      'profileImage': 'assets/images/login_background_0.jpg',
    };

    User user = User(
      id: RxInt(jsData['id']),
      name: RxString(jsData['name']),
      level: RxString(jsData['level']) ,
      part: RxString(jsData['part']),
      department: RxString(jsData['department']),
      profileImage: RxString(jsData['profileImage']),
    );
    return user;
  }

  static void write() {}
}

class User {
  User({
    this.id,
    this.name,
    this.level,
    this.part,
    this.department,
    this.profileImage,
  });

  RxInt? id;
  RxString? name ;
  RxString? level;
  RxString? part;
  RxString? department;
  RxString? profileImage;


}
