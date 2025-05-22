import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_doctor_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/doctor_table_view/doctor_table_component/popup_add_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/student_table_view/student_table_component/popup_add_student_component.dart';

class AddGroupPhonesCard extends GetView<DashboardDoctorTableController> {
  AddGroupPhonesCard({super.key});

  String? phone1;
  String? phone2;
  String? phone3;

  @override
  Widget build(BuildContext context) {
    phone1 = controller.doctorPhone1.text;
    phone2 = controller.doctorPhone2.text;
    phone3 = controller.doctorPhone3.text;
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
                          PopupAddComponent(
                            name: "Phone number 1",
                            controlName: phone1 as TextEditingController,
                            focusName: controller.phone1Focus,
                            inputType: TextInputType.number,
                          ),
                          PopupAddComponent(
                            name: "Phone number 2",
                            controlName: phone2 as TextEditingController,
                            focusName: controller.phone2Focus,
                            inputType: TextInputType.number,
                          ),
                          PopupAddComponent(
                            name: "Phone number 3",
                            controlName: phone3 as TextEditingController,
                            focusName: controller.phone3Focus,
                            inputType: TextInputType.number,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: () {
                                    controller.addGroup(
                                      phone1!,
                                      phone2!,
                                      phone3!,
                                    );
                                    Navigator.of(Get.overlayContext!).pop();
                                  },
                                  text: "Add"),
                              CustomButton(
                                onPress: () => Get.back(result: null),
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
