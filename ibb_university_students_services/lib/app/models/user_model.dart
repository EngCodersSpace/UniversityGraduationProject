import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ibb_university_students_services/app/models/structuers/user_structure.dart';

class UserModel {

  static User? _user;
  static bool userLogin(String id,String password){
    // simulate make request and get response
    bool responseStat = false;
    if(id == "1" && password == "12345678"){
      responseStat = true;
      String token = "token";
      Map<String,dynamic> response = {
        'id': 2070093,
        'name': 'Shehab AL-Saidi',
        'level': '4th',
        'part': 'Electrical engineering',
        'department': 'Computer engineering',
        'profileImage': 'assets/images/login_background_0.jpg',
      };
      _user = userResponseToUser(response);

    }
    return responseStat;
  }
  static User fetchUser() {
    if(_user != null){
      return _user!;
    }
    // simulate make request and get response
    Map<String,dynamic> response = {
      'id': 2070093,
      'name': 'Shehab AL-Saidi',
      'level': '4th',
      'part': 'Electrical engineering',
      'department': 'Computer engineering',
      'profileImage': 'assets/images/login_background_0.jpg',
    };
    User user = userResponseToUser(response);
    return user;
  }

  static User userResponseToUser(Map<String,dynamic> response){
    User user = User(
      id: RxInt(response['id']),
      name: RxString(response['name']),
      level: RxString(response['level']) ,
      part: RxString(response['part']),
      department: RxString(response['department']),
      profileImage: RxString(response['profileImage']),
    );
    return user;
  }

  static void write() {}
}



