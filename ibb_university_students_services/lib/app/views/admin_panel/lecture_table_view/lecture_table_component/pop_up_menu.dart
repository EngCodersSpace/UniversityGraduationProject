import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/permission_checker.dart';

// ignore: must_be_immutable
class MyWidget extends GetView<DashboardLectureTableController> {
  MyWidget({super.key, required this.content});
  Rx<Lecture?> content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.05,
      height: Get.height * 0.06,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          if (content.value?.lectureStatus != null) ...[
            Container(
              decoration: BoxDecoration(
                color: (content.value?.lectureStatus ?? false)
                    ? Colors.greenAccent
                    : Colors.redAccent,
                borderRadius: const BorderRadius.all(Radius.circular(32)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: (content.value?.lectureStatus ?? false)
                  ? CustomText("Confirmed".tr)
                  : CustomText("Canceled".tr),
            ),
          ],
          if ((PermissionUtils.checkPermission(
              target: "Lectures", action: "write"))) ...[
            const SizedBox(
              width: 8,
            ),
            SizedBox(
              height: 24,
              width: 24,
              child: PopupMenuButton<String>(
                onSelected: (val) =>
                    controller.more(val, data: content.toJson()),
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
                // child: Icon(Icons.more_vert_outlined,
                //     color: AppColors.mainTextColor),
              ),
            )
          ]
        ],
      ),
    );
  }
}
