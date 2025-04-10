import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import '../models/helper_models/result.dart';
import '../utils/local_lisenter.dart';

/// Controller responsible for managing the login screen logic.
/// Handles user input, form validation, authentication, and localization.
class LoginController extends GetxController {
  // Text controllers for login form fields
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  // Form key and focus nodes for field validation and navigation
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode idFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();


  // Reactive variables to control UI behavior
  RxBool logging = false.obs;                // Indicates active login process
  RxBool loggingFiled = false.obs;           // Whether login failed
  RxString loggingFiledMessage = "".obs;     // Error message for UI
  RxDouble heightScale = 0.6.obs;            // Used for scaling login card height responsively
  RxBool rememberMe = false.obs;             // Tracks checkbox value
  RxBool loading = true.obs;                 // Indicates initial loading state

  @override
  void onInit() async {
    // Pre-fill credentials for development/testing
    id.text = "1";
    password.text = "1234pass@";

    super.onInit();
    loading.value = false;
  }

  @override
  void onReady() {
    // Called when the controller is fully initialized and the view is ready
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes to free memory
    id.dispose();
    password.dispose();
    idFocus.dispose();
    passwordFocus.dispose();
  }

  /// Navigates to the forgot password screen
  void forgotPassword() {
    Get.toNamed("/forgotPassword");
  }

  /// Handles login flow:
  /// - Validates the form
  /// - Sends request via UserRepository
  /// - Updates UI based on response
  Future<void> onLogin() async {
    logging.value = true;

    if (formKey.currentState!.validate()) {
      Result res = await UserRepository.userLogin(
        id.text,
        password.text,
        rememberMe: rememberMe.value,
      );

      // Handle various login outcomes based on status code
      if (res.statusCode == 200) {
        Get.offNamed("/main"); // Navigate to main screen on success
      } else if (res.statusCode == 900) {
        loggingFiledMessage.value =
        "no internet connection \n please check your connection ";
        loggingFiled.value = true;
      } else if (res.statusCode == 401) {
        loggingFiledMessage.value = "password or id is wrong";
        loggingFiled.value = true;
      } else if (res.statusCode == 404) {
        loggingFiledMessage.value = "no such user exist";
        loggingFiled.value = true;
      } else {
        loggingFiledMessage.value =
        "something get wrong \n please check your connection ";
        loggingFiled.value = true;
      }
    }

    logging.value = false;
  }

  /// Updates the state of the "Remember Me" checkbox
  void toggleRememberMe(bool? val) async {
    rememberMe.value = val ?? false;
  }

  /// Changes the app language using custom locale listener
  void changeLang(String lang) {
    LocaleListener.updateLocale(lang);
  }
}
