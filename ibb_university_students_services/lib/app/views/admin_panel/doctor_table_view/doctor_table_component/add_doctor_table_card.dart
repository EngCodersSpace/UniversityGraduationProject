import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_doctor_table_controller.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/doctor_table_view/doctor_table_component/add_group_phones_card.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/doctor_table_view/doctor_table_component/popup_add_component.dart';

class PopUpAddDoctorCard extends GetView<DashboardDoctorTableController> {
  const PopUpAddDoctorCard({super.key});

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
                height: Get.height * 0.9,
                width: Get.width * 0.4,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PopupAddComponent(
                            name: "Doctor ID",
                            controlName: controller.doctorId,
                            focusName: controller.doctorIdFocus,
                            inputType: TextInputType.number,
                          ),
                          PopupAddComponent(
                            name: "Name",
                            controlName: controller.name,
                            focusName: controller.nameFocus,
                            inputType: TextInputType.name,
                          ),
                          PopupAddComponent(
                            name: "Date Of Birth",
                            controlName: controller.dateOfBirth,
                            focusName: controller.dateOfBirthFocus,
                            inputType: TextInputType.datetime,
                          ),
                          PopupAddComponent(
                            name: "Email",
                            controlName: controller.email,
                            focusName: controller.emailFocus,
                            inputType: TextInputType.emailAddress,
                          ),
                          PopupAddComponent(
                            name: "Role",
                            controlName: controller.role,
                            focusName: controller.roleFocus,
                            inputType: TextInputType.number,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomText("Phone Number",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold)),
                              CustomButton(
                                onPress: () async {
                                  Get.dialog(AddGroupPhonesCard());
                                },
                                text: "Add Group Numbers",
                              )
                            ],
                          ),
                          PopupAddComponent(
                            name: "College",
                            controlName: controller.college,
                            focusName: controller.collegeFocus,
                            inputType: TextInputType.multiline,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText("Doctor Section".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.23,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                        value: controller.SectionId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.SectionId.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.2,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Section sectionI
                                              in (controller.section.values)) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: sectionI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.2,
                                                  child: CustomText(
                                                    sectionI.name ??
                                                        "Unknown".tr,
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h3Bold),
                                                    softWrap: false,
                                                  )),
                                            ));
                                          }
                                          return items;
                                        },
                                        items: [
                                          for (Section sectionI in (controller
                                              .section.values)) ...[
                                            DropdownMenuItem<int?>(
                                                value: sectionI.id,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                      sectionI.name ??
                                                          "Unknown",
                                                      style: AppTextStyles
                                                          .secStyle(
                                                              textHeader:
                                                                  AppTextHeaders
                                                                      .h3Bold),
                                                    ),
                                                    // Divider(color: AppColors.highlightTextColor,)
                                                  ],
                                                )),
                                          ]
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                          PopupAddComponent(
                            name: "Acadimic Degree",
                            controlName: controller.acadimicDegree,
                            focusName: controller.acadimicFocus,
                            inputType: TextInputType.multiline,
                          ),
                          PopupAddComponent(
                            name: "Administrative Position",
                            controlName: controller.adminPosition,
                            focusName: controller.administrativeFocus,
                            inputType: TextInputType.multiline,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: controller.addDoctor, text: "Add"),
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
