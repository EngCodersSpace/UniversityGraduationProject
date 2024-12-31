// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import '../../../styles/app_colors.dart';
import '../../../models/exam_model.dart';
import '../../../utils/permission_checker.dart';

class ExamCard extends GetView<ExamTableController> {
  Rx<Exam?> content;

  ExamCard({
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
                          child: SecText(content.value?.date ?? ""),
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
                              child: SecText("${content.value?.day}".tr),
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
                    MainText(
                        content.value?.subject?.subjectName ?? "Unknown".tr),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              SecText("Hall:   ",
                                  fontWeight: FontWeight.bold, fontSize: 19),
                              SecText(content.value?.hall ?? "unknown".tr)
                            ],
                          ),
                          Row(
                            children: [
                              SecText("Time:   ",
                                  fontWeight: FontWeight.bold, fontSize: 19),
                              SecText(DateTimeUtils.formatStringTime(
                                  time: content.value?.examTime ?? "00:00:00")),
                            ],
                          ),
                        ],
                      ),
                    ]),
              )
            ],
          ),
        ));
  }
}
