import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_student_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/student_table_view/student_table_component/popup_add_student_component.dart';

class AddGroupPhoneNumberCard extends GetView<DashboardStudentTableController> {
  const AddGroupPhoneNumberCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "PopUpInsertCard",
          child: Material(
            color: AppColors.mainCardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(
                  color: AppColors.inverseCardColor,
                  width: 3,
                )),
            child: SizedBox(
                height: Get.height * 0.5,
                width: Get.width * 0.35,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PopupAddStudentComponent(
                            name: "Phone number 1",
                            controlName: controller.studentPhone1,
                            focusName: controller.phone1Focus,
                            inputType: TextInputType.number,
                          ),
                          PopupAddStudentComponent(
                            name: "Phone number 2",
                            controlName: controller.studentPhone2,
                            focusName: controller.phone2Focus,
                            inputType: TextInputType.number,
                          ),
                          PopupAddStudentComponent(
                            name: "Phone number 3",
                            controlName: controller.studentPhone3,
                            focusName: controller.phone3Focus,
                            inputType: TextInputType.number,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: () {
                                    controller.addGroup(
                                        int.parse(
                                            controller.studentPhone1.text),
                                        int.parse(
                                            controller.studentPhone2.text),
                                        int.parse(
                                            controller.studentPhone1.text));
                                    Navigator.of(Get.overlayContext!).pop();
                                  },
                                  text: "Add"),
                              CustomButton(
                                onPress: () =>
                                    Navigator.of(Get.overlayContext!).pop(),
                                text: "Close".tr,
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
          ),
        ),
      ),
    );
  }
}
