import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../../components/buttons.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/screen_utils.dart';



class BooksAddFilesCard extends GetView<LibraryController> {
  const BooksAddFilesCard({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(
        id: "BooksPiker",
        builder: (ctx) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "PopUpInsertCard",
                  child: Material(
                    color: AppColors.tabBackColor,
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
                                  (controller.mode == "add")
                                      ? ("Add Books").tr
                                      : ("Add Books Request to ").tr,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h1Bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                        SizedBox(
                                            width: (Get.width *0.2),
                                            child: CustomText("Program".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold))),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width: Get.width / 3,
                                      child: Center(
                                        child: Obx(
                                              () => DropdownButton(
                                            items: (controller.sections.entries
                                                .map((e) {
                                              return DropdownMenuItem<int>(
                                                  value: e.value.id,
                                                  child: SizedBox(
                                                    width: (ScreenUtils
                                                        .isPhoneScreen())
                                                        ? (Get.width / 3) - 30
                                                        : (Get.width / 5.5) * 0.6,
                                                    child: CustomText(
                                                      e.value.name ?? "unknown",
                                                      style:
                                                      AppTextStyles.mainStyle(
                                                        textHeader:
                                                        AppTextHeaders.h5Bold,
                                                      ),
                                                    ),
                                                  ));
                                            }).toList()),
                                            onChanged:
                                            controller.changeDepartment,
                                            value: controller
                                                .selectedDepartment.value,
                                            underline: const SizedBox(),
                                            iconEnabledColor:
                                            AppColors.mainCardColor,
                                            dropdownColor:
                                            AppColors.inverseCardColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: (Get.width *0.2),
                                        child: CustomText("Level".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold))),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius:
                                        BorderRadius.circular(24),
                                      ),
                                      width: Get.width*0.5,
                                      child: Center(
                                        child: Obx(
                                              () => DropdownButton(
                                            items: controller.levels,
                                            onChanged:
                                            controller.changeLevel,
                                            value: controller
                                                .selectedLevel.value,
                                            underline: const SizedBox(),
                                            iconEnabledColor:
                                            AppColors.mainCardColor,
                                            dropdownColor:
                                            AppColors.inverseCardColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: (Get.width *0.2),
                                        child: CustomText("Category".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold))),
                                    Container(
                                        width: Get.width*0.5,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                          color: AppColors.inverseCardColor,
                                          borderRadius: BorderRadius.circular(24)
                                      ),
                                      child: Center(
                                        child: Obx(()=>DropdownButton(
                                          value: controller.selectedCategory.value,
                                          iconEnabledColor:
                                          AppColors.mainCardColor,
                                          underline: const SizedBox(),
                                          dropdownColor: AppColors.inverseCardColor,
                                          onChanged: (val) {
                                            if(val == null)return;
                                          },
                                          isExpanded: true,
                                          menuWidth: Get.width*0.7,
                                          items: [
                                            for(var (i,s) in controller.categories.indexed)...[
                                              DropdownMenuItem(
                                                  value: i,
                                                  child:  SizedBox(
                                                    width: (Get.width *0.5) * 0.75,
                                                      child: CustomText(s,style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold),))
                                              ),
                                            ]
                                          ],
                                        )),
                                      ),)
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                  child: Container(
                                    width: Get.width * 0.9,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.inverseCardColor),
                                      borderRadius: BorderRadius.circular(24),
                                      // color: AppColors.highlightTextColor
                                      //     .withOpacity(0.1),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                for (int i = 0;
                                                    i <
                                                        (controller.selectedFiles
                                                            .length);
                                                    i++) ...[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                  controller
                                                                      .selectedFiles[
                                                                          i]
                                                                      .name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: AppTextStyles.secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h3Bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 24,
                                                          width: 24,
                                                          child: PopupMenuButton<
                                                              String>(
                                                            onSelected: (val) =>
                                                                controller
                                                                    .filesMore(
                                                                        val, i),
                                                            color: AppColors
                                                                .inverseCardColor,
                                                            itemBuilder: (ctx) =>
                                                                [
                                                              PopupMenuItem(
                                                                  value: "Delete",
                                                                  child:
                                                                      CustomText(
                                                                    "Delete".tr,
                                                                    style: AppTextStyles.mainStyle(
                                                                        textHeader:
                                                                            AppTextHeaders
                                                                                .h3Bold),
                                                                  )),
                                                              PopupMenuItem(
                                                                  value: "reName",
                                                                  child:
                                                                      CustomText(
                                                                    "Rename".tr,
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
                                                      ((controller.selectedFiles
                                                              .length) -
                                                          1)) ...[
                                                    Divider(
                                                      color:
                                                          AppColors.secTextColor,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomButton(
                                  onPress: () async => controller.pickFiles(),
                                  text: "Select Books".tr,
                                  size: Size(Get.width * 0.86, 40),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomButton(
                                  onPress: controller.uploadBooks,
                                  text: (controller.mode == "add")
                                      ? ("Upload Books").tr
                                      : ("Upload And Add Request").tr,
                                  size: Size(Get.width * 0.86, 40),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomButton(
                                  onPress: controller.closeAddBooksDialog,
                                  text: "Close".tr,
                                  size: Size(Get.width * 0.86, 40),
                                )
                              ],
                            ))),
                  ),
                ),
              ),
            ));
  }
}
