import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_text_v2.dart';
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
          padding: const EdgeInsets.all(32.0),
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
                  height: Get.height * 0.4,
                  width: Get.width - 32,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
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
                        // Divider(
                        //   color: AppColors.inverseCardColor,
                        //   thickness: 0.3,
                        // ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image(
                                  image: AssetImage(
                                      controller.selectedBook["image"] ?? ""),
                                  width: 120,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomText(
                                        "Title :${controller.selectedBook["name"]}",style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal),),
                                    CustomText("Authors :",style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal)),
                                    CustomText("Pages : ",style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal)),
                                    CustomText("Size :",style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                        Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomButton(
                                  text: "Download",
                                  onPress: () {},
                                  size: const Size(120, 40),
                                ),
                                CustomButton(
                                  text: "About",
                                  onPress: () {},
                                  size: const Size(120, 40),
                                ),
                              ],
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
