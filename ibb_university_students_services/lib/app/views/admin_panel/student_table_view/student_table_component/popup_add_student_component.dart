import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_student_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

// ignore: must_be_immutable
class PopupAddStudentComponent
    extends GetView<DashboardStudentTableController> {
  PopupAddStudentComponent({
    super.key,
    required this.name,
    required this.controlName,
    required this.focusName,
    required this.inputType,
  });

  String name;
  TextEditingController controlName;
  FocusNode focusName;
  TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Icon(
            //   Icons.account_balance,
            //   size: 40,
            //   color: AppColors.inverseIconColor,
            // ),
            // const SizedBox(
            //   width: 10,
            // ),
            CustomText(name.tr,
                style:
                    AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)),
          ],
        ),
        CustomTextFormField(
          controller: controlName,
          // validator: controller.validateEntryYear,
          keyboardType: inputType,
          labelText: name.tr,
          focusNode: focusName,
          width: (Get.width - 12) * 0.23,
        ),
      ],
    );
  }
}
