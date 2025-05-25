import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_text_v2.dart';
import '../../../services/http_provider.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

// ignore: must_be_immutable
class PopUpBookInfoCard extends GetView<LibraryController> {
  // ignore: prefer_const_constructors_in_immutables
  PopUpBookInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Hero(
              tag: "PupCard",
              child: Material(
                color: AppColors.tabBackColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.inverseCardColor, width: 4),
                      borderRadius: BorderRadius.circular(32)),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppColors.secTextColor,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  CustomText(
                                    "Book Information",
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.secTextColor,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: SizedBox(
                              height: (Get.height ) * 0.3,
                              width: (Get.height ) * 0.25,
                              child: HttpProvider.httpImage(imageUrl: "get-imageOfbook?id=${controller.selectedBook?.id}",secImageUrl:controller.selectedBook?.displayImage )),
                        ),
                        SizedBox(height: 32,),
                        SizedBox(width: 8,),
                        OverflowBox(
                          fit: OverflowBoxFit.deferToChild,
                          maxWidth: Get.width * 0.82,
                          maxHeight: Get.height *0.24,
                          child: Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            radius: Radius.circular(24),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        "Title :",
                                        style: AppTextStyles.secStyle(
                                            textHeader:
                                                AppTextHeaders.h3Normal),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          controller.selectedBook?.title ??
                                              "Unknown".tr,
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Authors :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            controller.selectedBook?.author ??
                                                "Unknown".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Pages :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            "${controller.selectedBook?.numberOfPages ?? "Unknown".tr}",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Edition :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                              AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            controller.selectedBook?.edition ?? "Unknown".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Category :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                              AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            controller.selectedBook?.category ?? "Unknown".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Subject :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                              AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            controller.selectedBook?.subject?.subjectName ?? "Unknown".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Size :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            "${controller.selectedBook?.fileSize ?? "Unknown".tr}",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Added By :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                              AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            "${controller.selectedBook?.addedBy ?? "Unknown".tr}",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Obx(()=>Column(
                              children: [
                                if (
                                controller.selectedBook?.status?.value ==
                                    "Downloading") ...[
                                  SizedBox(
                                    width: Get
                                        .width,
                                    child:
                                    Row(
                                      children: [
                                        Expanded(child: LinearProgressIndicator(color: AppColors.inverseCardColor, backgroundColor: AppColors.highlightTextColor.withValues(alpha: 0.2), value: (controller.selectedBook?.progress?.value.toDouble() ?? 0) / 100)),
                                        SizedBox(width: 4),
                                        CustomText(
                                          "${controller.selectedBook?.progress?.value ?? "1"}%",
                                          textAlign: TextAlign.start,
                                          style: AppTextStyles.highlightStyle(textHeader: AppTextHeaders.h5Bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ]else...[
                                  if(controller.selectedBook?.downloaded.value??false)...[
                                    CustomButton(
                                      text: "Open",
                                      onPress: controller.openFile,
                                      // size: const Size(120, 40),
                                    ),
                                  ]else...[
                                    CustomButton(
                                      text: "Download",
                                      onPress: controller.downloadBooks,
                                      // size: const Size(120, 40),
                                    ),
                                  ],
                                ],
                              ],
                            )),
                            CustomButton(
                              text: "Delete From Disk",
                              onPress: controller.deleteBooksFromStorage,
                            ),
                            CustomButton(
                              text: "Delete From Server",
                              onPress: controller.deleteBooksFromServer,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}
