import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_role_users_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
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
