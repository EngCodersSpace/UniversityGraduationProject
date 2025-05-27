import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../../controllers/admin_panel_controllers/header_of_view_controller_interface.dart';

// ignore: must_be_immutable
class HeaderOfViewComponent extends GetView {
  String tableName;
  @override
  HeaderOfViewControllerInterface controller;

  HeaderOfViewComponent(
      {super.key, required this.tableName, required this.controller});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.offNamed("/main");
                },
                icon: Icon(Icons.arrow_back_outlined),
              ),
              SizedBox(
                width: width * 0.2,
                child: CustomText(
                  tableName,
                  style: AppTextStyles.secStyle(
                    textHeader: AppTextHeaders.h1Bold,
                  ),
                ),
              ),
              CustomTextFormField(
                labelText: "Search",
                // labelStyle: AppTextStyles.mainStyle(
                //   textHeader: AppTextHeaders.h2Bold,
                // ),
                controller: controller.searchController,
                // icon: Icons.search_rounded,
                color: AppColors.inverseCardColor,
                width: width * 0.25,
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
                          onTap: controller.export, //send function of upload
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Export",
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
                          onTap: controller.import, //send function of download
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Import",
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
