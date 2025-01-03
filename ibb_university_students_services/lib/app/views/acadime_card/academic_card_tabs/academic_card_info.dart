import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

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
                            SecText(
                              (controller.user?.value.id??-99999).toString(),
                              textColor: AppColors.inverseCardColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
                                      child: SecText(
                                        "بطاقة جامعية",
                                        textColor: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8,),
                                    Center(
                                      child: SecText(
                                        "النظام ال${((controller.user?.value as Student).systemData?["ar"])}",
                                        textColor: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 24,),
                                    Center(
                                      child: SecText(
                                        controller.user?.value.nameData?["ar"]??"unknown",
                                        textColor: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
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
                            child: SecText(
                              "كلية ${controller.user?.value.collegeNameData?["ar"]??"??"} - كهربائية - ${controller.user?.value.section?.nameData?["ar"]}",
                              textColor: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: SecText(
                          "   جامعة إب    ",
                          textColor: Colors.black,
                          fontWeight: FontWeight.bold,
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
                          child: MainText((controller.user?.value as Student).enrollmentYear??"??"),
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
