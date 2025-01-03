import 'package:get/get_utils/src/get_utils/get_utils.dart';

class Validators{

  static String? validateID(String? id) {
    bool valid = false;
    if (id == "" || id == null) {
      return "required ID";
    } else if (GetUtils.isNumericOnly(id)) {
      valid = true;
    }
    else if (GetUtils.isEmail(id)) {
      valid = true;
    }
    return (valid)?null:"Invalid ID";
  }

  static String? validatePassword(String? password) {
    if (GetUtils.isNullOrBlank(password ?? "") == null) {
      return "Password required";
    } else if (password!.length < 8) {
      return "Password must be at least 8 characters  long";
    } else {
      return null;
    }
  }

}