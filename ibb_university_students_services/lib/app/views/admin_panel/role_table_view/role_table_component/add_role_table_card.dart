import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_role_users_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/role_table_view/role_table_component/add_role_component.dart';

class AddRoleTableCard extends GetView<DashboardRoleUsersTableController> {
  const AddRoleTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "PopUpInsertCard",
          child: Material(
            color: AppColors.mainCardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(
                  color: AppColors.inverseCardColor,
                  width: 3,
                )),
            child: SizedBox(
                height: Get.height * 0.4,
                width: Get.width * 0.4,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AddRoleComponent(
                            name: "Role Name",
                            controlName: controller.roleName,
                            focusName: controller.nameFocus,
                            inputType: TextInputType.multiline,
                          ),
                          AddRoleComponent(
                            name: "Role Type",
                            controlName: controller.roleType,
                            focusName: controller.typeFocus,
                            inputType: TextInputType.multiline,
                          ),
                          CustomText(
                            "${"Roles".tr}:",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            spacing: 10,
                            children: controller.roles.values.map((role) {
                              final selected = controller.selectedRoles
                                  .contains("role_${role.id}");
                              return FilterChip(
                                label: CustomText(role.name ?? '??',
                                    style: (selected)
                                        ? AppTextStyles.mainStyle(
                                            textHeader: AppTextHeaders.h3Normal)
                                        : AppTextStyles.secStyle(
                                            textHeader:
                                                AppTextHeaders.h3Normal)),
                                color: WidgetStateProperty.resolveWith((state) {
                                  if (state.contains(WidgetState.selected)) {
                                    return AppColors.inverseCardColor;
                                  } else {
                                    return AppColors.tabBackColor;
                                  }
                                }),
                                selected: selected,
                                checkmarkColor: AppColors.tabBackColor,
                                onSelected: (val) {
                                  selected
                                      ? controller.selectedRoles
                                          .remove("role_${role.id}")
                                      : controller.selectedRoles
                                          .add("role_${role.id}");
                                },
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: controller.addRole, text: "Add"),
                              CustomButton(
                                onPress: () =>
                                    Navigator.of(Get.overlayContext!).pop(),
                                text: "Close".tr,
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
          ),
        ),
      ),
    );
  }
}
