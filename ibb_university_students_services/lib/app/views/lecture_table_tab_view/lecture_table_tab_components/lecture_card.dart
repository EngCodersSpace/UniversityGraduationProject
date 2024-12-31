// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:intl/intl.dart';

import '../../../controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import '../../../styles/app_colors.dart';
import '../../../models/lecture_model.dart';
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
    // DateTime endTime = DateTimeUtils.timeOfDayFromString(((content.value?.startTime ?? "00:00:00")).add(Duration(minutes: content.value?.duration ?? 0));
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
                height: height * 0.52,
                width: double.maxFinite,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.inverseCardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          child: SecText(
                              "${DateTimeUtils.formatStringTime(time: content.value?.startTime ?? "00:00:00")} - ${DateTimeUtils.addToStringTime(time: content.value?.startTime ?? "00:00:00",duration: Duration(minutes: content.value?.duration ?? 0))}"),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: (content.value?.lectureStatus ?? false)
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: (content.value?.lectureStatus ?? false)
                                  ? SecText("Canceled".tr)
                                  : SecText("Confirmed".tr),
                            ),
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
                                        child: SecText(
                                          "TemporaryReplace".tr,
                                          textColor: AppColors.mainTextColor,
                                        )),
                                    PopupMenuItem(
                                        value: "Update",
                                        child: SecText(
                                          "Update".tr,
                                          textColor: AppColors.mainTextColor,
                                        )),
                                    PopupMenuItem(
                                        value: "Delete",
                                        child: SecText(
                                          "Delete".tr,
                                          textColor: AppColors.mainTextColor,
                                        )),
                                    PopupMenuItem(
                                        value: "Confirm",
                                        child: SecText(
                                          "Confirm".tr,
                                          textColor: AppColors.mainTextColor,
                                        )),
                                    PopupMenuItem(
                                        value: "Cancel",
                                        child: SecText(
                                          "Cancel".tr,
                                          textColor: AppColors.mainTextColor,
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
                    MainText(
                        content.value?.subject?.subjectName ?? "Unknown".tr),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 22),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SecText("Doctor: ",
                                  fontWeight: FontWeight.bold, fontSize: 19),
                              SecText(
                                  "Dr.${content.value?.instructor?.name ?? "unknown".tr}")
                            ],
                          ),
                          Row(
                            children: [
                              SecText("Hall: ",
                                  fontWeight: FontWeight.bold, fontSize: 19),
                              SecText(content.value?.hall ?? "unknown".tr)
                            ],
                          ),
                        ],
                      ),
                      if (content.value?.description != null &&
                          (content.value?.description?.isNotEmpty ??
                              false)) ...[
                        Row(
                          children: [
                            SecText("Description: ",
                                fontWeight: FontWeight.bold, fontSize: 19),
                            SecText(content.value?.description ?? "unknown".tr)
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
