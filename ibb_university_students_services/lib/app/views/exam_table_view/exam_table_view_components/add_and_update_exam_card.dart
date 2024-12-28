import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import 'package:ibb_university_students_services/app/models/subject_model.dart';
import '../../../components/buttons.dart';
import '../../../components/text_field.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/date_and_time_piker.dart';

class PopUpIAddAndUpdateExamCard extends GetView<ExamTableController> {
  const PopUpIAddAndUpdateExamCard({super.key});



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
                          CustomText("${controller.mode} Exam",
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
                                  child: Obx(()=>DropdownButton<String>(
                                    value: controller.subject.value,
                                    icon: Icon(Icons.arrow_drop_down_sharp,
                                        color: AppColors.inverseCardColor),
                                    underline: const SizedBox(),
                                    dropdownColor: AppColors.mainCardColor,
                                    onChanged: (val) {
                                      if(val == null)return;
                                      controller.subject.value = val;
                                    },
                                    isExpanded: true,
                                    menuWidth: Get.width*0.7,
                                    selectedItemBuilder: (_){
                                      List<Widget> items = [];
                                      for(Subject subjectI in controller.subjects??[]) {
                                        items.add(DropdownMenuItem<String>(
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
                                      for(Subject subjectI in controller.subjects??[])...[
                                        DropdownMenuItem<String>(
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
                                    Icons.calendar_month,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Date".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.dateController,
                                // validator: controller.validateDate,
                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                                labelText: 'Date'.tr,
                                focusNode: controller.dateFocus,
                                readOnly: true,
                                onTap: () => datePiker(context,controller.dateController),
                                onFieldSubmitted: (e) {
                                  controller.timeFocus.requestFocus();
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
                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                                // validator: controller.validateTime,
                                labelText: "Time".tr,
                                focusNode: controller.timeFocus,
                                readOnly: true,
                                onTap: () => timePiker(context,controller.timeController),
                                onFieldSubmitted: (e) {
                                  controller.dayFocus.requestFocus();
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
                                  CustomText("Day".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
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
                                  child: Obx(()=>DropdownButton<String>(
                                    value: controller.day.value,
                                    icon: Icon(Icons.arrow_drop_down_sharp,
                                        color: AppColors.inverseCardColor),
                                    underline: const SizedBox(),
                                    dropdownColor: AppColors.mainCardColor,
                                    onChanged: (val) {
                                      controller.day.value = val ?? "Saturday";
                                      controller.hallFocus.requestFocus();
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: "Saturday",
                                        child:  CustomText("Saturday".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "Sunday",
                                        child:  CustomText("Sunday".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "Monday",
                                        child:  CustomText("Monday".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "Tuesday",
                                        child:  CustomText("Tuesday".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "Wednesday",
                                        child:  CustomText("Wednesday".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "Thursday",
                                        child:  CustomText("Thursday".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),),
                                      ),
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
                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                                // validator: controller.validateEntryYear,
                                labelText: "Hall".tr,
                                focusNode: controller.hallFocus,
                                onFieldSubmitted: (e) {
                                  controller.dateFocus.requestFocus();
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
                                text: controller.mode.value,
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
