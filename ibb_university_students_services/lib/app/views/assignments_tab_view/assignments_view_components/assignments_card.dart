// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../../models/assignment_model.dart';
import '../../../styles/app_colors.dart';
import '../../../utils/permission_checker.dart';

class AssignmentsCard extends GetView<ExamTableController> {
  Rx<Assignment?> content;

  AssignmentsCard({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.mainCardColor,
            border: Border(
              bottom: BorderSide(
                  color: AppColors.inverseCardColor, width: 2, strokeAlign: 1),
              right: BorderSide(
                  color: AppColors.inverseCardColor, width: 2, strokeAlign: 1),
              left: BorderSide(
                  color: AppColors.inverseCardColor, width: 2, strokeAlign: 1),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 5),
              )
            ],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.inverseCardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.mainCardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child:
                              CustomText(content.value?.assignmentDate ?? ""),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.mainCardColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CustomText(
                                  "${content.value?.assignmentDay}".tr),
                            ),
                            if ((PermissionUtils.checkPermission(
                                target: "Exams", action: "edit"))) ...[
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: PopupMenuButton<String>(
                                  onSelected: (val) => controller.more(val,
                                      data: content.toJson()),
                                  color: AppColors.inverseCardColor,
                                  itemBuilder: (ctx) => [
                                    PopupMenuItem(
                                        value: "Update",
                                        child: CustomText(
                                          "Edit".tr,
                                          style: AppTextStyles.mainStyle(
                                              textHeader: AppTextHeaders.h3),
                                        )),
                                    PopupMenuItem(
                                        value: "Delete",
                                        child: CustomText(
                                          "Delete".tr,
                                          style: AppTextStyles.mainStyle(
                                              textHeader: AppTextHeaders.h3),
                                        )),
                                  ],
                                  child: Icon(Icons.more_vert_outlined,
                                      color: AppColors.mainTextColor),
                                ),
                              )
                            ]
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    MainText(content.value?.title ?? "Unknown".tr),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            "${"Doctor".tr}:",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomText(
                            content.value?.doctor?.name ?? "unknown".tr,
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          CustomText(
                            "${"Due Date".tr}:",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomText(
                            content.value?.dueDate ?? "00:00:00",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomText(
                            (content.value?.assignmentDay??"").tr,
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if ((PermissionUtils.checkPermission(
                          target: "Assignments", action: "doctorView")))
                        ...[
                          CustomButton(
                            onPress: () {},
                            text: "Add Attachments".tr,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomButton(
                            onPress: () {},
                            text: "Show Students".tr,
                          ),
                        ]
                      else
                        ...[
                          CustomButton(
                            onPress: () {},
                            text: "Show Attachments".tr,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomButton(
                            onPress: () {},
                            text: "Upload Assignment".tr,
                          ),
                        ],
                    ]),
              )
            ],
          ),
        ));
  }
}