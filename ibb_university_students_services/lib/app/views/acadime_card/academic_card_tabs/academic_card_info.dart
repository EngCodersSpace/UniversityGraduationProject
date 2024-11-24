import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/globals.dart';

class AcademicCardInfo extends GetView {
  const AcademicCardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    print(Get.height*0.65/2.6);
    return SizedBox(
      width: Get.width* 0.88,
      child: Card(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
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
                              data: '2070093',
                              barcode: Barcode.code128(),
                              height: 50,
                              width:Get.height*0.65/2.6,
                            ),
                          ],
                        ),
                        SecText(
                          "2070093",
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
                                    "النظام العام",
                                    textColor: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 24,),
                                Center(
                                  child: SecText(
                                    "شهاب درهم محمد الصايدي",
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
                    width: 16,
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
                          "كلية الهندسة - كهربائية - حاسبات وتحكم",
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
                      child: MainText("2019/2020"),
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
      ),
    );
  }
}
