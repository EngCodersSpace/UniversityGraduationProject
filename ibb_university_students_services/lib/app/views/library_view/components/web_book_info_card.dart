import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

// ignore: must_be_immutable
class WebBookInfoCard extends GetView<LibraryController> {
  // ignore: prefer_const_constructors_in_immutables
  WebBookInfoCard({super.key});

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
                  width: Get.width * 0.4,
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
                              height: (Get.height) * 0.2,
                              width: (Get.height) * 0.15,
                              child: CachedNetworkImage(
                                imageUrl:
                                    controller.selectedBook?.displayImage ??
                                        "assets/images/library/file.png",
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              )),
                        ),
                        SizedBox(
                          height: 26,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        OverflowBox(
                          fit: OverflowBoxFit.deferToChild,
                          maxWidth: Get.width * 0.38,
                          maxHeight: Get.height * 0.27,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Edition :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            controller.selectedBook?.edition ??
                                                "Unknown".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Category :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            controller.selectedBook?.category ??
                                                "Unknown".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Subject :",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)),
                                      Expanded(
                                        child: CustomText(
                                            controller.selectedBook?.subject
                                                    ?.subjectName ??
                                                "Unknown".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Normal)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                          height: 5,
                        ),
                        SizedBox(
                          width: Get.width * 0.15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              CustomButton(
                                text: "Download",
                                onPress: () {},
                                // size: const Size(120, 40),
                              ),
                              CustomButton(
                                text: "Delete From Disk",
                                onPress: () {},
                              ),
                              CustomButton(
                                text: "Delete From Server",
                                onPress: () {},
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}
