import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import 'package:ibb_university_students_services/app/models/instructor_model.dart';
import '../../../components/buttons.dart';
import '../../../components/text_field.dart';
import '../../../models/subject_model.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/date_time_utils.dart';

class PopUpIAddAndUpdateLectureCard extends GetView<LectureController> {
  const PopUpIAddAndUpdateLectureCard({super.key});



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

                )
            ),
            child: SizedBox(
                height: Get.height * 0.6,
                width: Get.width,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText("${controller.mode} Lecture",
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Subject".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width*0.45,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)
                                ),
                                child: Center(
                                  child: Obx(()=>DropdownButton<String?>(
                                    value: controller.subjectId.value,
                                    icon: Icon(Icons.arrow_drop_down_sharp,
                                        color: AppColors.inverseCardColor),
                                    underline: const SizedBox(),
                                    dropdownColor: AppColors.mainCardColor,
                                    onChanged: (val) {
                                      if(val == null)return;
                                      controller.subjectId.value = val;
                                      controller.doctorId.value = controller.subjects?[controller.subjectId.value]?.instructors?.values.first.id;
                                    },
                                    isExpanded: true,
                                    menuWidth: Get.width*0.7,
                                    selectedItemBuilder: (_){
                                      List<Widget> items = [];
                                      for(Subject subjectI in (controller.subjects?.values.toList())??[]) {
                                        items.add(DropdownMenuItem<String?>(
                                          value: subjectI.id,
                                          child: SizedBox(
                                              width: Get.width * 0.28,
                                              child: CustomText(
                                                subjectI.subjectName ?? "",
                                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                                                softWrap: false,
                                              )),
                                        ));
                                      }
                                      return items;
                                    },
                                    items: [
                                      for(Subject subjectI in (controller.subjects?.values.toList())??[])...[
                                        DropdownMenuItem<String?>(
                                            value: subjectI.id,
                                            child:  Column(
                                              children: [
                                                CustomText(subjectI.subjectName??"",style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),),
                                                // Divider(color: AppColors.highlightTextColor,)
                                              ],
                                            )
                                        ),
                                      ]
                                    ],
                                  )),
                                ),)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Doctor".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width*0.45,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)
                                ),
                                child: Center(
                                  child: Obx(()=>DropdownButton<int?>(
                                    value: controller.doctorId.value,
                                    icon: Icon(Icons.arrow_drop_down_sharp,
                                        color: AppColors.inverseCardColor),
                                    underline: const SizedBox(),
                                    dropdownColor: AppColors.mainCardColor,
                                    onChanged: (val) {
                                      controller.doctorId.value = val;
                                    },
                                    isExpanded: true,
                                    menuWidth: Get.width*0.7,
                                    selectedItemBuilder: (_){
                                      List<Widget> items = [];
                                      for(Instructor instructorI in (controller.subjects?[controller.subjectId.value]?.instructors?.values.toList())??[]) {
                                        items.add(DropdownMenuItem<int?>(
                                          value: instructorI.id,
                                          child: SizedBox(
                                              width: Get.width * 0.28,
                                              child: CustomText(
                                                instructorI.name ?? "",
                                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                                                softWrap: false,
                                              )),
                                        ));
                                      }
                                      return items;
                                    },
                                    items: [
                                      for(Instructor instructorI in (controller.subjects?[controller.subjectId.value]?.instructors?.values.toList())??[])...[
                                        DropdownMenuItem<int?>(
                                            value: instructorI.id,
                                            child:  CustomText(instructorI.name??"unknown".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),)
                                        ),
                                      ]
                                    ],
                                  )),
                                ),)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Time".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.timeController,
                                // validator: controller.validateTime,
                                labelText: "Time".tr,
                                focusNode: controller.timeFocus,
                                readOnly: true,
                                onTap: () => DateTimeUtils.timePiker(context,controller.timeController),
                                onFieldSubmitted: (e) {
                                  controller.durationFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Duration".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.durationController,
                                labelText: "Duration".tr,
                                keyboardType: TextInputType.number,
                                focusNode: controller.durationFocus,
                                onFieldSubmitted: (e) {
                                  controller.entryYearFocus.requestFocus();
                                },
                                width: (Get.width-12)*0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Hall".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.hallController,
                                // validator: controller.validateEntryYear,
                                keyboardType: TextInputType.text,
                                labelText: "Hall".tr,
                                focusNode: controller.entryYearFocus,
                                onFieldSubmitted: (e) {
                                  controller.phoneFocus.requestFocus();
                                },
                                width: (Get.width-12)*0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                onPress: controller.submit,
                                text: controller.mode,
                              ),
                              CustomButton(
                                onPress: () => Get.back(result: null),
                                text: "Close",
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
