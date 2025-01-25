import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

import '../../../components/custom_text_v2.dart';
import '../../../styles/text_styles.dart';

class AcademicCardInfo extends GetView<AcademicCardController> {
  const AcademicCardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(()=>SizedBox(
      width: Get.width* 0.88,
      child: Card(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          children: [
            RotatedBox(quarterTurns: 1,child: Container(
                width: Get.height*0.599,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/ibb_university_logo.png",
                      ),
                      scale: 0.7,
                      opacity: 0.1,
                    )
                )
            ),),
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 8,),
                                BarcodeWidget(
                                  drawText: false,
                                  data: (controller.user?.value.id??-99999).toString(),
                                  barcode: Barcode.code128(),
                                  height: 50,
                                  width:Get.height*0.65/2.6,
                                ),
                              ],
                            ),
                            CustomText(
                              (controller.user?.value.id??-99999).toString(),
                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Row(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Icon(Icons.person,size: 80,),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Center(
                                      child: CustomText(
                                        "بطاقة جامعية",
                                          style: AppTextStyles.customColorStyle(color: Colors.black, textHeader: AppTextHeaders.h2Bold)
                                      ),
                                    ),
                                    const SizedBox(height: 8,),
                                    Center(
                                      child: CustomText(
                                        "النظام ال${((controller.user?.value as Student).systemData?["ar"])}",
                                          style: AppTextStyles.customColorStyle(color: Colors.black, textHeader: AppTextHeaders.h2Bold)
                                      ),
                                    ),
                                    const SizedBox(height: 24,),
                                    Center(
                                      child: CustomText(
                                        controller.user?.value.nameData?["ar"]??"unknown",
                                          style: AppTextStyles.customColorStyle(color: Colors.black, textHeader: AppTextHeaders.h2Bold)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: AppColors.inverseCardColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: CustomText(
                              "كلية ${controller.user?.value.collegeNameData?["ar"]??"??"} - كهربائية - ${controller.user?.value.section?.nameData?["ar"]}",
                                style: AppTextStyles.customColorStyle(color: Colors.white, textHeader: AppTextHeaders.h2Bold)
                            ),
                          ),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: CustomText(
                          "   جامعة إب    ",
                            style: AppTextStyles.customColorStyle(color: Colors.black, textHeader: AppTextHeaders.h2Bold)
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            color: AppColors.inverseCardColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: CustomText((controller.user?.value as Student).enrollmentYear??"??",
                              style: AppTextStyles.customColorStyle(color: Colors.white, textHeader: AppTextHeaders.h2Bold)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Image.asset(
                        "assets/images/ibb_university_logo.png",
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    ));
  }
}
