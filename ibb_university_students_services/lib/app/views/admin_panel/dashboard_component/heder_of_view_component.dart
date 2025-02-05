import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_main_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

// ignore: must_be_immutable
class HederOfViewComponent extends GetView<DashboardMainController> {
  String tablename;
  late Function upload;
  late Function download;

  HederOfViewComponent(
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
                  style: AppTextStyles.mainStyle(
                    textHeader: AppTextHeaders.h1Bold,
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.2,
                child: Container(
                  width: width * 0.15,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search",
                        fillColor: AppColors.backColor,
                        filled: true,
                        suffixIcon: const Icon(
                          Icons.search_outlined,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        )),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.2,
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
                      width: width * 0.12,
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
            ],
          ),
        ],
      ),
    );
  }
}
