// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ibb_university_students_services/app/components/buttons.dart';
// import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
// import 'package:ibb_university_students_services/app/components/text_field.dart';
// import 'package:ibb_university_students_services/app/controllers/main_controller.dart';
// import 'package:ibb_university_students_services/app/styles/app_colors.dart';
// import 'package:ibb_university_students_services/app/styles/text_styles.dart';
// import 'package:ibb_university_students_services/app/utils/validators.dart';

// class LoginToDashboard extends GetView<MainController> {
//   const LoginToDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Material(
//             color: AppColors.mainCardColor,
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(32),
//                 side: BorderSide(
//                   color: AppColors.inverseCardColor,
//                   width: 3,
//                 )),
//             child: Container(
//               color: AppColors.tabBackColor,
//               padding: EdgeInsets.all(10),
//               width: Get.width * 0.2,
//               height: Get.height * 0.4,
//               child: Column(
//                 children: [
//                   CustomText(
//                     "Login to dashboard",
//                     style: AppTextStyles.secStyle(
//                         textHeader: AppTextHeaders.h2Bold),
//                   ),
//                   Row(
//                     children: [
//                       CustomText(
//                         "User ID".tr,
//                         style: AppTextStyles.secStyle(
//                             textHeader: AppTextHeaders.h3Bold),
//                       ),
//                       CustomTextFormField(
//                         controller: controller.id,
//                         validator: (id) => Validators.validateID(id),
//                         labelText: "User ID",
//                       ),
//                       SizedBox(
//                         height: Get.height * 0.05,
//                       ),
//                       CustomTextFormField(
//                           controller: controller.password,
//                           validator: (pwd) => Validators.validatePassword(pwd),
//                           labelText: "Password".tr,
//                           isPassword: true,
//                           onFieldSubmitted: (e) {
//                             controller.onLogin();
//                           }),
//                       SizedBox(
//                         height: Get.height * 0.03,
//                       ),
//                       Obx(() => (controller.logging.value)
//                           ? CustomButton(
//                               onPress: controller.onLogin,
//                               text: 'logging',
//                               icon: CircularProgressIndicator(
//                                 color: AppColors.backColor,
//                               ),
//                               size: Size(Get.width * 0.8, 40),
//                             )
//                           : CustomButton(
//                               onPress: controller.onLogin,
//                               text: 'login'.tr,
//                               icon: (Get.locale.toString() == "en_US")
//                                   ? Icon(
//                                       Icons.login,
//                                       color: AppColors.mainTextColor,
//                                     )
//                                   : RotatedBox(
//                                       quarterTurns: 2,
//                                       child: Icon(Icons.login,
//                                           color: AppColors.mainTextColor)),
//                               size: Size(Get.width * 0.15, 40),
//                             )),
//                     ],
//                   )
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }
