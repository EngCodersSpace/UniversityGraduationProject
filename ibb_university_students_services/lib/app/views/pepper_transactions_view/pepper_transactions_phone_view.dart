import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/pepper_transactions_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import '../../components/custom_text_v2.dart';
import '../../components/text_field.dart';
import '../../styles/text_styles.dart';

class PepperTransactionsPhoneView
    extends GetView<PepperTransactionsController> {
  const PepperTransactionsPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.tabBackColor,
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => (controller.loadingState.value)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back_outlined,
                                color: AppColors.inverseCardColor,
                              )),
                          CustomText(
                              "Academic Transactions".tr,
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: controller.searchText,
                              focusNode: controller.searchFocus,
                              onChange: controller.searching,
                              onTapOutside: (e){controller.searchFocus.unfocus();},
                              labelText: "Search",
                              color: AppColors.inverseCardColor,
                              prefixIcon: Icons.search_rounded,
                            ),
                          ),
                          IconButton(
                              onPressed: controller.filteringIconClick,
                              icon: Icon(
                                Icons.filter_list_alt,
                                color: AppColors.inverseCardColor,
                              )),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.transactions.length,
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {},
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.inverseIconColor,
                                    child: CustomText(
                                      "${i + 1}",
                                      style: AppTextStyles.mainStyle(
                                          textHeader: AppTextHeaders.h2Bold),
                                    ),
                                  ),
                                  title: CustomText(
                                    "name",
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                  trailing: CustomText(
                                    "name",
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                  subtitle: GetBuilder<PepperTransactionsController>(
                                      id: "statusTextBuilder",
                                      builder: (context) {
                                        return CustomText(
                                          "subTitle",
                                          textAlign: TextAlign.start,
                                          style: AppTextStyles.highlightStyle(
                                              textHeader: AppTextHeaders.h3Bold),
                                        );
                                      }),
                                ),
                                Divider(
                                  color: AppColors.inverseCardColor.withAlpha(30),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ),
        ));
  }
}
