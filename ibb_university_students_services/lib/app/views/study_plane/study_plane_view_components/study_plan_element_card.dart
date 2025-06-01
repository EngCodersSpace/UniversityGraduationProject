// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/study_plane_controller.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import '../../../models/study_plan_elements_model/study_plan_elements.dart';
import '../../../repositories/user_repository.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class StudyPlanElementCard extends GetView<StudyPlaneController> {
  Rx<StudyPlanElement> studyPlanElement;

  StudyPlanElementCard({
    required this.studyPlanElement,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(() => (ScreenUtils.isPhoneScreen())
        ? Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.mainCardColor,
              border: Border(
                bottom: BorderSide(
                    color: AppColors.inverseCardColor,
                    width: 2,
                    strokeAlign: 1),
                right: BorderSide(
                    color: AppColors.inverseCardColor,
                    width: 2,
                    strokeAlign: 1),
                left: BorderSide(
                    color: AppColors.inverseCardColor,
                    width: 2,
                    strokeAlign: 1),
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
                  constraints: BoxConstraints(
                      // minHeight: Get.height * 0.3,
                      ),
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.inverseCardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            child: CustomText(
                                "${studyPlanElement.value.subject?.units} ${"Units".tr}"),
                          ),
                          if ((UserRepository.checkPermission(
                              target: "study_plan", action: "write"))) ...[
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: PopupMenuButton<String>(
                                onSelected: (val) => controller.more(val,
                                    data: studyPlanElement.toJson()),
                                color: AppColors.inverseCardColor,
                                itemBuilder: (ctx) => [
                                  PopupMenuItem(
                                      value: "Edit",
                                      child: CustomText(
                                        "Edit".tr,
                                        style: AppTextStyles.mainStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      )),
                                  PopupMenuItem(
                                      value: "Delete",
                                      child: CustomText(
                                        "Delete".tr,
                                        style: AppTextStyles.mainStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      )),
                                ],
                                child: Icon(Icons.more_vert_outlined,
                                    color: AppColors.mainTextColor),
                              ),
                            )
                          ]
                          // if(PermissionUtils.checkPermission("addLecture"))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          CustomText(
                            "${"Subject".tr}:",
                            style: AppTextStyles.mainStyle(
                              textHeader: AppTextHeaders.h1Bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          CustomText(
                            studyPlanElement.value.subject?.subjectName ??
                                "Unknown".tr,
                            style: AppTextStyles.mainStyle(
                              textHeader: AppTextHeaders.h2Bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomText(
                        "${"Description".tr}:",
                        style: AppTextStyles.mainStyle(
                          textHeader: AppTextHeaders.h1Bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: CustomText(
                              studyPlanElement.value.subject?.description ??
                                  "Unknown".tr,
                              style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h2Bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  "${"Doctor".tr}:   ",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h2Bold),
                                ),
                                CustomText(
                                  "${"Dr".tr}.${studyPlanElement.value.subject?.instructors?[studyPlanElement.value.doctorId]?.name ?? ((studyPlanElement.value.subject?.instructors?.isNotEmpty ?? false) ? studyPlanElement.value.subject?.instructors?.values.first.name : "Unknown".tr)}",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                )
                              ],
                            ),
                          ],
                        ),
                        // if (studyPlanElement.value?.description != null &&
                        //     (studyPlanElement.value?.description?.isNotEmpty ??
                        //         false)) ...[
                        //   Row(
                        //     children: [
                        //       CustomText(
                        //         "Description: ",
                        //         style: AppTextStyles.secStyle(
                        //             textHeader: AppTextHeaders.h3Bold),
                        //       ),
                        //       CustomText(
                        //         studyPlanElement.value?.description ?? "unknown".tr,
                        //         style: AppTextStyles.secStyle(
                        //             textHeader: AppTextHeaders.h3Bold),
                        //       )
                        //     ],
                        //   ),
                        // ]
                      ]),
                )
              ],
            ),
          )
        : Container(
            width: Get.width * 0.3,
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.mainCardColor,
              border: Border(
                bottom: BorderSide(
                    color: AppColors.inverseCardColor,
                    width: 2,
                    strokeAlign: 1),
                right: BorderSide(
                    color: AppColors.inverseCardColor,
                    width: 2,
                    strokeAlign: 1),
                left: BorderSide(
                    color: AppColors.inverseCardColor,
                    width: 2,
                    strokeAlign: 1),
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
                  constraints: BoxConstraints(
                      // minHeight: Get.height * 0.3,
                      ),
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.inverseCardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            child: CustomText(
                                "${studyPlanElement.value.subject?.units} ${"Units".tr}"),
                          ),
                          if ((UserRepository.checkPermission(
                              target: "study_plan", action: "write"))) ...[
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: PopupMenuButton<String>(
                                onSelected: (val) => controller.more(val,
                                    data: studyPlanElement.toJson()),
                                color: AppColors.inverseCardColor,
                                itemBuilder: (ctx) => [
                                  PopupMenuItem(
                                      value: "Edit",
                                      child: CustomText(
                                        "Edit".tr,
                                        style: AppTextStyles.mainStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      )),
                                  PopupMenuItem(
                                      value: "Delete",
                                      child: CustomText(
                                        "Delete".tr,
                                        style: AppTextStyles.mainStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      )),
                                ],
                                child: Icon(Icons.more_vert_outlined,
                                    color: AppColors.mainTextColor),
                              ),
                            )
                          ]
                          // if(PermissionUtils.checkPermission("addLecture"))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          CustomText(
                            "${"Subject".tr}:",
                            style: AppTextStyles.mainStyle(
                              textHeader: AppTextHeaders.h1Bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          CustomText(
                            studyPlanElement.value.subject?.subjectName ??
                                "Unknown".tr,
                            style: AppTextStyles.mainStyle(
                              textHeader: AppTextHeaders.h2Bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomText(
                        "${"Description".tr}:",
                        style: AppTextStyles.mainStyle(
                          textHeader: AppTextHeaders.h1Bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: CustomText(
                              studyPlanElement.value.subject?.description ??
                                  "Unknown".tr,
                              style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h2Bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  "${"Doctor".tr}:   ",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h2Bold),
                                ),
                                CustomText(
                                  "${"Dr".tr}.${studyPlanElement.value.subject?.instructors?[studyPlanElement.value.doctorId]?.name ?? ((studyPlanElement.value.subject?.instructors?.isNotEmpty ?? false) ? studyPlanElement.value.subject?.instructors?.values.first.name : "Unknown".tr)}",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                )
                              ],
                            ),
                          ],
                        ),
                        // if (studyPlanElement.value?.description != null &&
                        //     (studyPlanElement.value?.description?.isNotEmpty ??
                        //         false)) ...[
                        //   Row(
                        //     children: [
                        //       CustomText(
                        //         "Description: ",
                        //         style: AppTextStyles.secStyle(
                        //             textHeader: AppTextHeaders.h3Bold),
                        //       ),
                        //       CustomText(
                        //         studyPlanElement.value?.description ?? "unknown".tr,
                        //         style: AppTextStyles.secStyle(
                        //             textHeader: AppTextHeaders.h3Bold),
                        //       )
                        //     ],
                        //   ),
                        // ]
                      ]),
                )
              ],
            ),
          ));
  }
}
