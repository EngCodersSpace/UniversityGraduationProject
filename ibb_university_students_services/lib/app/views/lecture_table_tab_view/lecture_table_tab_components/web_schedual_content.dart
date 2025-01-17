import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import 'web_lecture_card.dart';

// ignore: must_be_immutable
class WebSchedualContent extends GetView<LectureController> {
  double width = Get.width;
  double height = Get.height;
  WebSchedualContent({super.key, required this.day, required this.index});
  String day;
  int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.114,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  day.tr,
                  style: AppTextStyles.customColorStyle(
                      textHeader: AppTextHeaders.h2,
                      color: AppColors.secTextColor),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: height * 0.04,
              ),
              SizedBox(height: height * 0.02),
              if (controller.selectedDay(index)?.isEmpty ?? true) ...[
                SizedBox(
                  height: height * 0.08,
                ),
                Center(
                    child: CustomText(
                  controller.fieldMessage.value,
                  style: AppTextStyles.secStyle(AppTextHeaders.h2),
                )),
                IconButton(
                    onPressed: () async => controller.refresh(),
                    icon: const Icon(
                      Icons.refresh,
                      size: 40,
                    )),
              ],
              for (int i = 0;
                  i < (controller.selectedDay(index)?.length ?? 0);
                  i++) ...[
                WebLectureCard(
                  content:
                      Rx(controller.selectedDay(index)?.values.toList()[i]),
                  height: height * 0.1 * (1 / 2),
                ),
                SizedBox(
                  height: height * 0.01,
                )
              ],
            ],
          ),
        ],
      ),
    );
  }
}
