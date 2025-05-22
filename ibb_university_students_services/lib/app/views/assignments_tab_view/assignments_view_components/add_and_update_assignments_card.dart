import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import '../../../components/buttons.dart';
import '../../../components/text_field.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import 'add_assignments_group_card.dart';

class PopUpIAddAndUpdateAssignmentsCard
    extends GetView<AssignmentsTabController> {
  const PopUpIAddAndUpdateAssignmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                height: (controller.mode == "Add")
                    ? Get.height * 0.65
                    : Get.height * 0.45,
                width: Get.width,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText("${controller.mode} Assignment",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h2Bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.title,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Title".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.titleController,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                // validator: controller.validateEntryYear,
                                labelText: "Title".tr,
                                focusNode: controller.hallFocus,
                                onFieldSubmitted: (e) {
                                  controller.submit();
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
                                    Icons.calendar_month,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Due Date".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.dueDateController,
                                // validator: controller.validateDate,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                labelText: 'Date'.tr,
                                focusNode: controller.dueDateFocus,
                                readOnly: true,
                                onTap: () => DateTimeUtils.datePiker(context,
                                    controller: controller.dueDateController),
                                onFieldSubmitted: (e) {
                                  // controller.timeFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Icon(
                          //           Icons.person,
                          //           size: 40,
                          //           color: AppColors.inverseIconColor,
                          //         ),
                          //         const SizedBox(
                          //           width: 10,
                          //         ),
                          //         CustomText("Doctor".tr,
                          //             style: AppTextStyles.secStyle(
                          //                 textHeader: AppTextHeaders.h3Bold)),
                          //       ],
                          //     ),
                          //     CustomTextFormField(
                          //       // controller: controller.timeController,
                          //       style: AppTextStyles.secStyle(
                          //           textHeader: AppTextHeaders.h3Bold),
                          //       // validator: controller.validateTime,
                          //       labelText: "Doctor".tr,
                          //       // focusNode: controller.timeFocus,
                          //       readOnly: true,
                          //       onFieldSubmitted: (e) {
                          //         controller.submit();
                          //       },
                          //       width: (Get.width - 12) * 0.46,
                          //     ),
                          //   ],
                          // ),
                          if (controller.mode == "Add")
                            Obx(() => Column(
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: CustomText("Groups",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.88,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.inverseCardColor),
                                          color: AppColors.tabBackColor,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: ((Get.width * 0.85) / 7),
                                                child: CustomText("#",
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h2Bold)),
                                              ),
                                              SizedBox(
                                                width:
                                                    ((Get.width * 0.85) / 7) *
                                                        3,
                                                child: CustomText("Program",
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h2Bold)),
                                              ),
                                              SizedBox(
                                                width:
                                                    ((Get.width * 0.85) / 7) *
                                                        2,
                                                child: CustomText("Level",
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h2Bold)),
                                              ),
                                              SizedBox(
                                                width: ((Get.width * 0.85) / 7),
                                                child: CustomText("",
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h2Bold)),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: AppColors.inverseCardColor,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  for (var (index, item)
                                                      in controller
                                                          .groups.indexed) ...[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: ((Get.width *
                                                                  0.85) /
                                                              7),
                                                          child: CustomText(
                                                              "${index + 1}",
                                                              style: AppTextStyles
                                                                  .secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h2Bold)),
                                                        ),
                                                        SizedBox(
                                                          width: ((Get.width *
                                                                      0.85) /
                                                                  7) *
                                                              3,
                                                          child: CustomText(
                                                              "${controller.sections[item["section_id"]!]?.name}",
                                                              softWrap: false,
                                                              style: AppTextStyles
                                                                  .secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h2Bold)),
                                                        ),
                                                        SizedBox(
                                                          width: ((Get.width *
                                                                      0.85) /
                                                                  7) *
                                                              2,
                                                          child: CustomText(
                                                              "${item["level_id"]}",
                                                              style: AppTextStyles
                                                                  .secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h2Bold)),
                                                        ),
                                                        SizedBox(
                                                            width: ((Get.width *
                                                                    0.85) /
                                                                7),
                                                            child: IconButton(
                                                                onPressed: () =>
                                                                    controller
                                                                        .delGroup(
                                                                            index),
                                                                icon: Icon(Icons
                                                                    .delete)))
                                                      ],
                                                    ),
                                                  ]
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                )),
                          Column(
                            children: [
                              if (controller.mode == "Add")
                                CustomButton(
                                  onPress: () async {
                                    Get.dialog(PopUpIAddAssignmentsGroupCard());
                                  },
                                  text: "Add Group",
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
