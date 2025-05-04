import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../../models/helper_models/student_assignment_state/student_assignment_state.dart';
import '../../../styles/app_colors.dart';

// ignore: must_be_immutable
class AssignmentStudentList extends GetView<AssignmentsTabController> {
  AssignmentStudentList({required this.items, super.key});

  List<StudentAssignmentState> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.inverseCardColor,
        foregroundColor: AppColors.mainCardColor,
        title: CustomText(
          "Students List",
          style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h1Bold),
        ),
      ),
      body: Container(
        color: AppColors.tabBackColor,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            return Column(
              children: [
                ListTile(
                  onTap: () => controller.showStudentFiles(
                      controller.selectedAssignment,
                      stateId: items[i].id),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.inverseIconColor,
                    child: CustomText(
                      "${i + 1}",
                      style: AppTextStyles.mainStyle(
                          textHeader: AppTextHeaders.h2Bold),
                    ),
                  ),
                  title: CustomText(
                    "${items[i].studentName}",
                    textAlign: TextAlign.start,
                    style: AppTextStyles.secStyle(
                        textHeader: AppTextHeaders.h2Bold),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (val) =>
                        controller.changeState(val,items[i].studentId,items[i].id),
                    color: AppColors.inverseCardColor,
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                          value: "Accept",
                          child: CustomText(
                            "Accept".tr,
                            style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          )),
                      PopupMenuItem(
                          value: "Reject",
                          child: CustomText(
                            "Reject".tr,
                            style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          )),
                    ],
                    child: Icon(Icons.more_vert_outlined,
                        color: AppColors.inverseCardColor),
                  ),
                  subtitle: GetBuilder<AssignmentsTabController>(
                    id: "statusTextBuilder",
                    builder: (context) {
                      return CustomText(
                        "Status: ${items[i].state}",
                        textAlign: TextAlign.start,
                        style: AppTextStyles.highlightStyle(
                            textHeader: AppTextHeaders.h3Bold),
                      );
                    }
                  ),
                ),
                Divider(
                  color: AppColors.inverseCardColor.withAlpha(30),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
