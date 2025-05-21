import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/web_book_containar.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../components/book_container.dart';

class LecturesTab extends GetView<LibraryController> {
  const LecturesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: (ScreenUtils.isPhoneScreen())
            ? const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/images/library/istockphoto-867895848-612x612.jpg"),
              fit: BoxFit.fill),
        )
            : const BoxDecoration(
          image: DecorationImage(
              image:
              AssetImage("assets/images/library/weblibraryphoto.png"),
              fit: BoxFit.fill),
        ),
        height: Get.height * 0.74,
        child: Obx(
              () => (controller.loadingState.value)
              ? Center(
            child: CircularProgressIndicator(
              color: AppColors.mainCardColor,
            ),
          )
              : PageView(
            physics: AlwaysScrollableScrollPhysics(),
                onPageChanged: controller.onPageChange,
            controller: controller.myTabsControllers[0],
            children: [
              if (controller.books[controller.categories[0]]
                  ?.isEmpty ??
                  true) ...[
                RefreshIndicator(
            onRefresh: () async => controller.refresh(),
                  child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.3,
                        ),
                        Center(
                          child: CustomText(
                            "Empty".tr,
                            style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h2Bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
              for (int i = 0;
              i <
                  (controller
                      .books[controller.categories[0]]?.length ??
                      0);
              i += 12)
                RefreshIndicator(
                  onRefresh: () async => controller.refresh(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        if (controller.books[controller.categories[0]]
                            ?.isEmpty ??
                            true) ...[
                          SizedBox(
                            height: Get.height * 0.3,
                          ),
                          Center(
                            child: CustomText(
                              controller.fieldMessage.value,
                              style: AppTextStyles.mainStyle(
                                  textHeader: AppTextHeaders.h2Bold),
                            ),
                          ),
                          Center(
                            child: IconButton(
                                onPressed: () async =>
                                    controller.refresh(),
                                icon: Icon(
                                  Icons.refresh,
                                  color: AppColors.mainCardColor,
                                )),
                          )
                        ],
                        SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: Get.height * 0.70,
                          child: Wrap(
                              spacing: Get.width * 0.03,
                              runSpacing: Get.height * 0.045,
                              children: [
                                for (int j = i;
                                j < (i + 12) &&
                                    (j <
                                        (controller.books[controller.categories[2]]?.length ??
                                            0));
                                j++)
                                  if ((controller.books[controller.categories[0]]?.values
                                      .toList()[i]
                                      .sectionId ==
                                      controller
                                          .selectedDepartment
                                          .value ||
                                      controller.selectedDepartment.value ==
                                          -1) &&
                                      (controller.books[controller.categories[0]]?.values
                                          .toList()[i]
                                          .levelId ==
                                          controller
                                              .selectedLevel.value ||
                                          controller.selectedLevel.value ==
                                              -1) &&
                                      ((controller.books[controller.categories[0]]?.values
                                          .toList()[i]
                                          .title
                                          ?.toLowerCase().contains(controller.searchText.text.toLowerCase()) ??
                                          false) ||
                                          controller.searchText.text == "")) ...[
                                    Obx(() {
                                      if ((ScreenUtils.isPhoneScreen())) {
                                        return BookContainer(
                                          book: controller
                                              .books[controller
                                              .categories[0]]!
                                              .values
                                              .toList()[j],
                                        );
                                      } else {
                                        return WebBookContainar(
                                            book: controller
                                                .books[controller
                                                .categories[0]]!
                                                .values
                                                .toList()[j]);
                                      }
                                    })
                                  ]
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
