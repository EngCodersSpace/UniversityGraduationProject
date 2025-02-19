import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../components/book_container.dart';

class LecturesTab extends GetView<LibraryController> {
  const LecturesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/images/library/istockphoto-867895848-612x612.jpg"),
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
              for (int p = 0; p < controller.books.length; p += 16)
                RefreshIndicator(
                  onRefresh:() async => controller.refresh(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        if (controller.books.isEmpty) ...[
                          SizedBox(
                            height: Get.height*0.3,
                          ),
                          CustomText(
                            controller.fieldMessage.value,
                            style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h2Bold),
                          ),
                          IconButton(
                              onPressed: () async =>
                                  controller.refresh(),
                              icon:
                              Icon(Icons.refresh,color: AppColors.inverseCardColor,))
                        ],
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: Get.height * 0.70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (int i = p;
                              (i < controller.books.length) && (i < p + 16);
                              i += 3) ...[
                                SizedBox(
                                  height: (Get.height * 0.70) / 4,
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        for (int j = i;
                                        (j < controller.books.length) &&
                                            (j < i + 3);
                                        j++)
                                          Obx(
                                                () => BookContainer(
                                              book: controller.books.values.toList()[j],
                                            ),
                                          )
                                      ]),
                                ),
                              ],
                            ],
                          ),
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
