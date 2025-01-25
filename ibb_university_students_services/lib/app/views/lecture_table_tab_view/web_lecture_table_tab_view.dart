import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import 'package:ibb_university_students_services/app/views/lecture_table_tab_view/lecture_table_tab_components/web_schedual_content.dart';
import '../../components/custom_text_v2.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

// ignore: must_be_immutable
class WebLectureTableTabView extends GetView<LectureController> {
  double width = Get.width;
  double height = Get.height;

  WebLectureTableTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadState.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width,
                  height: height * 0.8,
                  padding: const EdgeInsets.only(left: 2, right: 2, top: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 6, top: 10),
                          decoration: BoxDecoration(
                              color: AppColors.backColor,
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WebSchedualContent(day: "Saturday", index: 0),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  WebSchedualContent(day: "Sunday", index: 1),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  WebSchedualContent(day: "Monday", index: 2),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  WebSchedualContent(day: "Tuseday", index: 3),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  WebSchedualContent(
                                      day: "Wednesday", index: 4),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  WebSchedualContent(day: "Thursday", index: 5),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: width,
                height: height * 0.2,
                color: AppColors.tabBackColor,
                child: Column(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.backColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 5),
                          )
                        ],
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomText(
                            "Section".tr,
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
                          ),
                          SizedBox(
                            width: width * 0.002,
                          ),
                          Container(
                            height: height * 0.08,
                            width: width * 0.14,
                            decoration: BoxDecoration(
                              color: AppColors.inverseIconColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Obx(
                                () => DropdownButton(
                                  items: controller.sections,
                                  onChanged: controller.changeDepartment,
                                  value: controller.selectedSection.value,
                                  underline: const SizedBox(),
                                  iconEnabledColor: AppColors.mainCardColor,
                                  dropdownColor: AppColors.inverseCardColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          CustomText(
                            "Level".tr,
                            style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
                          ),
                          SizedBox(
                            width: width * 0.002,
                          ),
                          Container(
                            height: height * 0.08,
                            width: width * 0.1,
                            decoration: BoxDecoration(
                              color: AppColors.inverseIconColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Obx(() => DropdownButton(
                                    items: controller.levels,
                                    onChanged: controller.changeLevel,
                                    value: controller.selectedLevel.value,
                                    underline: const SizedBox(),
                                    iconEnabledColor: AppColors.mainCardColor,
                                    dropdownColor: AppColors.inverseCardColor,
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          CustomText(
                            "Term".tr,
                            style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
                          ),
                          SizedBox(
                            width: width * 0.002,
                          ),
                          Container(
                            height: height * 0.08,
                            width: width * 0.13,
                            decoration: BoxDecoration(
                              color: AppColors.inverseIconColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Obx(() => DropdownButton(
                                    items: controller.terms,
                                    onChanged: controller.changeTerm,
                                    value: controller.selectedTerm.value,
                                    underline: const SizedBox(),
                                    iconEnabledColor: AppColors.mainCardColor,
                                    dropdownColor: AppColors.inverseCardColor,
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          CustomText(
                            "Year".tr,
                            style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
                          ),
                          SizedBox(
                            width: width * 0.002,
                          ),
                          Container(
                            height: height * 0.08,
                            width: width * 0.13,
                            decoration: BoxDecoration(
                              color: AppColors.inverseIconColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Obx(() => DropdownButton(
                                    items: controller.years,
                                    onChanged: controller.changeYear,
                                    value: controller.selectedYear.value,
                                    underline: const SizedBox(),
                                    iconEnabledColor: AppColors.mainCardColor,
                                    dropdownColor: AppColors.inverseCardColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
  }
}
