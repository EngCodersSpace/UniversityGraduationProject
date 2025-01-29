import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import '../../../components/buttons.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class FilesPickerCard extends GetView<AssignmentsTabController> {
  const FilesPickerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssignmentsTabController>(
        id: "AttachmentPiker",
        builder: (ctx) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "PopUpInsertCard",
                  child: Material(
                    color: AppColors.mainCardColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: AppColors.inverseCardColor,
                          width: 3,
                        )),
                    child: SizedBox(
                        height: Get.height * 0.7,
                        width: Get.width,
                        child: SafeArea(
                            minimum: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                CustomText(
                                  ("Attachments").tr,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h1Bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: Get.height * 0.55,
                                      width: Get.width * 0.9,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.inverseCardColor),
                                        borderRadius: BorderRadius.circular(24),
                                        // color: AppColors.highlightTextColor
                                        //     .withOpacity(0.1),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: Obx(() => Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      for (int i = 0;
                                                          i <
                                                              (controller
                                                                      .assignments
                                                                      ?.value[controller
                                                                          .selectedAssignment]
                                                                      ?.attachment
                                                                      ?.length ??
                                                                  0);
                                                          i++) ...[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4,
                                                                  right: 4,
                                                                  bottom: 4),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .inverseIconColor,
                                                                child:
                                                                    CustomText(
                                                                  "${i + 1}",
                                                                  style: AppTextStyles.mainStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h2Bold),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        Get.width *
                                                                            0.6,
                                                                    child:
                                                                        CustomText(
                                                                      controller
                                                                              .assignments
                                                                              ?.value[controller.selectedAssignment]
                                                                              ?.attachment?[i]
                                                                              .path
                                                                              ?.split("/")
                                                                              .last ??
                                                                          "",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: AppTextStyles.secStyle(
                                                                          textHeader:
                                                                              AppTextHeaders.h3Bold),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        Get.width *
                                                                            0.6,
                                                                    child:
                                                                        CustomText(
                                                                      "Status: Not Uploaded",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: AppTextStyles.highlightStyle(
                                                                          textHeader:
                                                                              AppTextHeaders.h5Bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 24,
                                                                width: 24,
                                                                child:
                                                                    PopupMenuButton<
                                                                        String>(
                                                                  onSelected: (val) =>
                                                                      controller.more(
                                                                          val,
                                                                          data: {
                                                                        "index":
                                                                            i
                                                                      }),
                                                                  color: AppColors
                                                                      .inverseCardColor,
                                                                  itemBuilder:
                                                                      (ctx) => [
                                                                    PopupMenuItem(
                                                                        value:
                                                                            "DeleteFile",
                                                                        child:
                                                                            CustomText(
                                                                          "Delete"
                                                                              .tr,
                                                                          style:
                                                                              AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold),
                                                                        )),
                                                                    PopupMenuItem(
                                                                        value:
                                                                            "reUploadFile",
                                                                        child:
                                                                            CustomText(
                                                                          "ReUpload"
                                                                              .tr,
                                                                          style:
                                                                              AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold),
                                                                        )),
                                                                  ],
                                                                  child: Icon(
                                                                      Icons
                                                                          .more_horiz,
                                                                      color: AppColors
                                                                          .inverseCardColor),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: AppColors
                                                              .secTextColor,
                                                          thickness: 0.3,
                                                        ),
                                                      ]
                                                    ],
                                                  ))),
                                          CustomButton(
                                            onPress: () async =>
                                                controller.pickFiles(),
                                            text: "Add".tr,
                                            size: Size(Get.width * 0.86, 40),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomButton(
                                      onPress: controller.uploadAttachments,
                                      text: "Upload All".tr,
                                    ),
                                    CustomButton(
                                      onPress: () => Get.back(result: null),
                                      text: "Close".tr,
                                    ),
                                  ],
                                )
                              ],
                            ))),
                  ),
                ),
              ),
            ));
  }
}
