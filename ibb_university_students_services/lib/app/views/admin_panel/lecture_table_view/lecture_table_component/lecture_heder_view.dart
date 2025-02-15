import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

// ignore: must_be_immutable
class LectureHederView extends GetView<DashboardLectureTableController> {
  String tablename;
  late Function upload;
  late Function download;

  LectureHederView(
      {super.key,
      required this.tablename,
      required this.upload,
      required this.download});

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    // double height = Get.height;
    return Container(
      color: AppColors.tabBackColor,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: width * 0.2,
                child: CustomText(
                  tablename,
                  style: AppTextStyles.secStyle(
                    textHeader: AppTextHeaders.h1Bold,
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.3,
                child: Container(
                  width: width * 0.15,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    //problem of onChange
                    controller: controller.search,
                    onEditingComplete: () {
                      print("Editing Completed: ${controller.search.text}");
                      controller.search.text;
                    },
                    onChanged: (e) {
                      print(e);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.26,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.12,
                        decoration: BoxDecoration(
                          color: AppColors.backColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: upload(), //send function of upload
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Upload",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.inverseMainTextColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: width * 0.003,
                              ),
                              const Icon(Icons.file_upload_outlined),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Container(
                        width: width * 0.13,
                        decoration: BoxDecoration(
                          color: AppColors.backColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: download(), //send function of download
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Download",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.inverseMainTextColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: width * 0.003,
                              ),
                              const Icon(
                                Icons.file_download_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
