// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/custom_text_v2.dart';
import '../../../models/grads_model.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class ResultCard extends StatelessWidget {
  ResultCard({
    super.key,
    required this.grad,
    this.type = "even",
  });

  String type;
  Rx<Grad> grad;

  @override
  Widget build(BuildContext context) {
      String? subjectName = grad.value.subject?.subjectName??"";
    if(grad.value.isAbsent == true){
      subjectName = "|  ${grad.value.subject?.subjectName??""}";
    }
    TextStyle style = AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5);
    if (((grad.value.workGrad ?? -100) + (grad.value.examGrad ?? -100)) <
        48) {
      style = AppTextStyles.failedGrads(textHeader: AppTextHeaders.h5);
    } else {
      style = AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5);
    }
    return Obx(() => Container(
          width: double.maxFinite,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: (type == "even")?AppColors.inverseCardColor.withOpacity(0.6):AppColors.inverseCardColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 5),
              )
            ],
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: (type == "even")
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: ((Get.width - 16) * 2.5) / 7,
                      child: CustomText(
                        subjectName ?? "unknown",
                        style: style,
                      ),
                    ),
                    SizedBox(
                      width: ((Get.width - 16) * 0.5) / 7,
                      child: CustomText(
                        "${grad.value.subject?.units ?? "??"}",
                        style: style,
                      ),
                    ),
                    SizedBox(
                      width: ((Get.width - 16) * 1.25) / 7,
                      child: CustomText(
                        "${grad.value.workGrad ?? "??"}",
                        style: style,
                      ),
                    ),
                    SizedBox(
                      width: ((Get.width - 16) * 1.25) / 7,
                      child: CustomText(
                        "${grad.value.examGrad ?? "??"}",
                        style: style,
                      ),
                    ),
                    SizedBox(
                      width: ((Get.width - 16) * 0.55) / 7,
                      child: CustomText(
                        "${((grad.value.workGrad ?? -100) + (grad.value.examGrad ?? -100))}",
                        style: style,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: ((Get.width - 16) * 2.5) / 7,
                      child: CustomText(
                        "${subjectName}",
                        style: style,
                      ),
                    ),
                    SizedBox(
                      width: ((Get.width - 16) * 0.5) / 7,
                      child: CustomText(
                        "${grad.value.subject?.units ?? "??"}",
                        style: style,
                      ),
                    ),
                    SizedBox(
                      width: ((Get.width - 16) * 1.25) / 7,
                      child: CustomText(
                        "${grad.value.workGrad ?? "??"}",
                        style: style,
                      ),
                    ),
                    SizedBox(
                      width: ((Get.width - 16) * 1.25) / 7,
                      child: CustomText(
                        "${grad.value.examGrad ?? "??"}",
                        style: style,
                      ),
                    ),
                    SizedBox(
                      width: ((Get.width - 16) * 0.55) / 7,
                      child: CustomText(
                        "${((grad.value.workGrad ?? -100) + (grad.value.examGrad ?? -100))}",
                        style: style,
                      ),
                    ),
                  ],
                ),
        ));
  }
}
