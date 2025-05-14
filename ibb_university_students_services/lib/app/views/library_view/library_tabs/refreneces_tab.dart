import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/web_book_containar.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../components/book_container.dart';

class ReferencesTab extends GetView<LibraryController> {
  const ReferencesTab({super.key});

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
            controller: controller.booksPagesController,
            children: [
              RefreshIndicator(
                onRefresh: () async => controller.refresh(),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (controller.books.isEmpty) ...[
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
                              onPressed: () async => controller.refresh(),
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
                              for (int i = 0;
                              i < controller.books.length;
                              i ++)
                                if (controller.books.values
                                    .toList()[i]
                                    .category ==
                                    controller.categories[1] &&
                                    (controller.books.values
                                        .toList()[i]
                                        .sectionId ==
                                        controller
                                            .selectedDepartment
                                            .value ||
                                        controller.selectedDepartment
                                            .value ==
                                            -1) &&
                                    (controller.books.values
                                        .toList()[i]
                                        .levelId ==
                                        controller
                                            .selectedLevel.value ||
                                        controller
                                            .selectedLevel.value ==
                                            -1)&&
                                    ((controller.books.values.toList()[i].title?.contains(controller.searchText.text)??false) ||
                                        controller.searchText.text == "")) ...[
                                  Obx(
                                        () => (ScreenUtils.isPhoneScreen())
                                        ? BookContainer(
                                      book: controller
                                          .books.values
                                          .toList()[i],
                                    )
                                        : WebBookContainar(
                                        book: controller
                                            .books.values
                                            .toList()[i]),
                                  )
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
