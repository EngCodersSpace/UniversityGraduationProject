// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:intl/intl.dart';
import '../../../components/custom_text_v2.dart';
import '../../../controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import '../../../styles/app_colors.dart';
import '../../../models/lecture_model/lecture_model.dart';
import '../../../utils/date_time_utils.dart';
import '../../../utils/permission_checker.dart';

class LectureCard extends GetView<LectureController> {
  Rx<Lecture?> content;
  double height;

  LectureCard({
    required this.content,
    required this.height,
    super.key,
  });

  DateFormat timeFormat = DateFormat.Hms();

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
                constraints: BoxConstraints(
                  minHeight: height * 0.42,
                ),
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
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
                              "${DateTimeUtils.formatStringTime(time: content.value?.startTime ?? "00:00:00")} - ${DateTimeUtils.addToStringTime(time: content.value?.startTime ?? "00:00:00", duration: Duration(minutes: content.value?.duration ?? 0))}"),
                        ),
                        Row(
                          children: [
                            if (content.value?.lectureStatus != null) ...[
                              Container(
                                decoration: BoxDecoration(
                                  color: (content.value?.lectureStatus ?? false)
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: (content.value?.lectureStatus ?? false)
                                    ? CustomText("Confirmed".tr)
                                    : CustomText("Canceled".tr),
                              ),
                            ],
                            if ((PermissionUtils.checkPermission(
                                target: "Lectures", action: "add"))) ...[
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
                                        value: "TemporaryReplace",
                                        child: CustomText(
                                          "Temporary Replace".tr,
                                          style: AppTextStyles.mainStyle(
                                              textHeader: AppTextHeaders.h3Bold),
                                        )),
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
                                    PopupMenuItem(
                                        value: "Confirm",
                                        child: CustomText(
                                          "Confirm".tr,
                                          style: AppTextStyles.mainStyle(
                                              textHeader: AppTextHeaders.h3Bold),
                                        )),
                                    PopupMenuItem(
                                        value: "Cancel",
                                        child: CustomText(
                                          "Cancel".tr,
                                          style: AppTextStyles.mainStyle(
                                              textHeader: AppTextHeaders.h3Bold),
                                        )),
                                  ],
                                  child: Icon(Icons.more_vert_outlined,
                                      color: AppColors.mainTextColor),
                                ),
                              )
                            ]
                          ],
                        ),
                        // if(PermissionUtils.checkPermission("addLecture"))
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomText(
                        content.value?.subject?.subjectName ?? "Unknown".tr,style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h1Bold,),textAlign: TextAlign.center,),
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
                                "${"Dr".tr}.${content.value?.subject?.instructors?[content.value?.instructorId]?.name ?? "unknown".tr}",
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                "${"Hall".tr}:   ",
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h2Bold),
                              ),
                              CustomText(
                                content.value?.hall ?? "unknown".tr,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              )
                            ],
                          ),
                        ],
                      ),
                      if (content.value?.description != null &&
                          (content.value?.description?.isNotEmpty ??
                              false)) ...[
                        Row(
                          children: [
                            CustomText(
                              "Description: ",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold),
                            ),
                            CustomText(
                              content.value?.description ?? "unknown".tr,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold),
                            )
                          ],
                        ),
                      ]
                    ]),
              )
            ],
          ),
        ));
  }
}
