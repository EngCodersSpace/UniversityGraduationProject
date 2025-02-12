import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import '../../../components/buttons.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/permission_checker.dart';

// ignore: must_be_immutable
class AssignmentsAddFilesCard extends GetView<AssignmentsTabController> {
  const AssignmentsAddFilesCard({super.key});

   get _data {
    if (PermissionUtils.checkPermission(
        target: "Assignments", action: "addAttachments")) {
      return controller.assignments?.value[controller.selectedAssignment]
          ?.attachments?.values
          .toList();
    }
    return controller.assignments?.value[controller.selectedAssignment]
        ?.studentsStatus?.values.first.studentFiles?.values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    String? mode;
    if (PermissionUtils.checkPermission(
        target: "Assignments", action: "addAttachments")) {
      mode = "attachmentsFiles";
    }
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
                        height: Get.height * 0.85,
                        width: Get.width,
                        child: SafeArea(
                            minimum: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                CustomText(
                                  (mode == "attachmentsFiles")
                                      ? ("Attachments").tr
                                      : ("Assignment File").tr,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h1Bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: Get.height * 0.65,
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
                                          child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            for (int i = 0;
                                                i < (_data?.length ?? 0);
                                                i++) ...[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: AppColors
                                                          .inverseIconColor,
                                                      child: CustomText(
                                                        "${i + 1}",
                                                        style: AppTextStyles
                                                            .mainStyle(
                                                                textHeader:
                                                                    AppTextHeaders
                                                                        .h2Bold),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: SizedBox(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CustomText(
                                                              _data?[i].title ??
                                                                  "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: AppTextStyles
                                                                  .secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h3Bold),
                                                            ),
                                                            Obx(
                                                                () =>
                                                                    CustomText(
                                                                      "Status:  ${_data?[i].status?.value ?? "Uploaded"}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: AppTextStyles.highlightStyle(
                                                                          textHeader:
                                                                              AppTextHeaders.h5Bold),
                                                                    )),
                                                            Obx(() => Column(
                                                                  children: [
                                                                    if (_data?[i]
                                                                            .status
                                                                            ?.value ==
                                                                        "Uploading") ...[
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      SizedBox(
                                                                        width: Get
                                                                            .width,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(child: LinearProgressIndicator(color: AppColors.inverseCardColor, backgroundColor: AppColors.highlightTextColor.withValues(alpha: 0.2), value: (_data?[i].progress?.value.toDouble() ?? 0) / 100)),
                                                                            SizedBox(width: 4),
                                                                            CustomText(
                                                                              "${_data?[i].progress?.value ?? "1"}%",
                                                                              textAlign: TextAlign.start,
                                                                              style: AppTextStyles.highlightStyle(textHeader: AppTextHeaders.h5Bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ]
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          (_data?[i]
                                                                      .downloaded
                                                                      .value ??
                                                                  false)
                                                              ? controller
                                                                  .openFile(
                                                                      _data?[i]
                                                                          .path)
                                                              : controller
                                                                  .downloadAttachment();
                                                        },
                                                        icon: Icon((_data?[i]
                                                                    .downloaded
                                                                    .value ??
                                                                false)
                                                            ? (Icons
                                                                .folder_open)
                                                            : (Icons
                                                                .download))),
                                                    SizedBox(
                                                      height: 24,
                                                      width: 24,
                                                      child: PopupMenuButton<
                                                          String>(
                                                        onSelected: (val) =>
                                                            controller.more(val,
                                                                data: {
                                                              // "assignment_id": _data?[i].assignmentId??"",
                                                              "id": _data?[i].id
                                                            }),
                                                        color: AppColors
                                                            .inverseCardColor,
                                                        itemBuilder: (ctx) => [
                                                          (mode =="attachmentsFiles")?PopupMenuItem(
                                                              value: "DeleteAttachmentFile",
                                                              child: CustomText(
                                                                "Delete".tr,
                                                                style: AppTextStyles.mainStyle(
                                                                    textHeader:
                                                                        AppTextHeaders
                                                                            .h3Bold),
                                                              )):PopupMenuItem(
                                                              value:
                                                              "DeleteStudentAssignmentFile",
                                                              child: CustomText(
                                                                "Delete".tr,
                                                                style: AppTextStyles.mainStyle(
                                                                    textHeader:
                                                                    AppTextHeaders
                                                                        .h3Bold),
                                                              )),
                                                          PopupMenuItem(
                                                              value:
                                                                  "reUploadFile",
                                                              child: CustomText(
                                                                "ReUpload".tr,
                                                                style: AppTextStyles.mainStyle(
                                                                    textHeader:
                                                                        AppTextHeaders
                                                                            .h3Bold),
                                                              )),
                                                        ],
                                                        child: Icon(
                                                          Icons.more_horiz,
                                                          color: AppColors
                                                              .inverseCardColor,
                                                          size: 25,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              if (i !=
                                                  ((_data?.length ?? 0) -
                                                      1)) ...[
                                                Divider(
                                                  color: AppColors.secTextColor,
                                                  thickness: 0.3,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                              ] else ...[
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                              ]
                                            ]
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomButton(
                                  onPress: () async => (mode =="attachmentsFiles")?controller.pickAttachmentFiles():controller.pickStudentAssignmentsFiles(),
                                  text: "Add".tr,
                                  size: Size(Get.width * 0.86, 40),
                                ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomButton(
                                      onPress: () async =>  (mode =="attachmentsFiles")?controller.uploadAssignmentsFiles():controller.uploadStudentAssignmentsFiles(),
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
