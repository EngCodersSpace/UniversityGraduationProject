import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_main_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

class HederOfViewComponent extends GetView<DashboardMainController> {
  const HederOfViewComponent({super.key});

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    // double height=Get.height;
    return Container(
      color: AppColors.tabBackColor,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.3,
            child: CustomText(
              "table name",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h1Bold,
              ),
            ),
          ),
          SizedBox(
            width: width * 0.3,
            child: Row(
              children: [
                Container(
                  width: width * 0.12,
                  decoration: BoxDecoration(
                    color: AppColors.backColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {},
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
                  width: width * 0.12,
                  decoration: BoxDecoration(
                    color: AppColors.backColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {},
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
        ],
      ),
    );
  }
}
