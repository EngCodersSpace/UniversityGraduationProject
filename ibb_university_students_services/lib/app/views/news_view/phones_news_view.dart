import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/news_controller.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import '../../components/custom_text_v2.dart';
import '../../services/http_provider.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';
import '../../utils/date_time_utils.dart';

class PhonesNewsView extends GetView<NewsController> {
  const PhonesNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
      (controller.initState.value)
          ? Stack(
        children: [
          Container(
            color: AppColors.inverseCardColor.withAlpha(240),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        // onPressed: () => Get.back(),
                          onPressed: () => controller.saveNews(),
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: AppColors.mainCardColor,
                          )),
                      if (UserRepository.checkPermission(
                          target: "news", action: "write") &&
                          (UserRepository.isCurrentUser(1) ?? false))
                        ...[
                          IconButton(
                              onPressed: controller.toggleEdit,
                              icon: Icon(
                                Icons.edit_document,
                                color: AppColors.mainCardColor,
                              )),
                        ]
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      GetBuilder<NewsController>(
                        id: "imagePicker",
                        builder: (ctx) =>
                          Container(
                            height: Get.height * 0.24,
                            width: Get.width * 0.86,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  width: 3, color: AppColors.tabBackColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: HttpProvider.httpImage(
                                imageUrl: controller.imageFile?.path ?? "",
                                imageError: Image.asset(
                                  "assets/images/news_full_back.jpg",
                                  fit: BoxFit.fill,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      "assets/images/news_full_back.jpg",
                                      fit: BoxFit.fill,
                                    ),
                              ),
                            ),
                          ),),
                      if(controller.editing.value)
                        SizedBox(
                          height: Get.height * 0.24,
                          width: Get.width * 0.86,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: controller.pickImage,
                                icon: Icon(
                                  Icons.add_photo_alternate,
                                  size: 50,
                                  color: Colors.blueGrey,
                                )),
                          ),
                        ),
                      if(controller.progress >= 0)...[
                        CircularProgressIndicator(
                          color: Colors.blueAccent,
                          strokeWidth: 5,
                          value: controller.progress.value,
                        )
                      ]
                    ],
                  ),
                  SizedBox(height: 32),
                  Expanded(
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.08),
                      decoration: BoxDecoration(
                        color: AppColors.tabBackColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Get.width * 0.07)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          CustomTextFormField(
                            controller: controller.titleController,
                            enableBorder: false,
                            keyboardType: TextInputType.multiline,
                            readOnly: !controller.editing.value,
                            minLines: 1,
                            maxLines: 3,
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h1Bold),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              CustomText(
                                "${"By".tr} user_name - ",
                                style: AppTextStyles.highlightStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              Flexible(
                                child: CustomTextFormField(
                                  controller: controller.dateController,
                                  readOnly: true,
                                  style: AppTextStyles.highlightStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                  enableBorder: false,
                                  onTap: () =>
                                      DateTimeUtils.datePiker(
                                          context,
                                          controller:
                                          controller.dateController),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Expanded(
                              child: QuillEditor.basic(
                                controller: controller.quillController,
                                focusNode: controller.quillFocus,
                                config: QuillEditorConfig(),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (controller.showToolBar.value && controller.editing.value)
            Positioned(
              left: controller.toolbarPosition.value.dx,
              top: controller.toolbarPosition.value.dy,
              child: Draggable(
                feedback: buildToolbar(), // while dragging
                childWhenDragging: Container(), // empty while dragging
                onDraggableCanceled: controller.onDraggableCanceled,
                child: buildToolbar(),
              ),
            ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      )),
    );
  }

  Widget buildToolbar() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: Get.width * 0.9,
        child: QuillSimpleToolbar(
          controller: controller.quillController,
          config: QuillSimpleToolbarConfig(
              showHeaderStyle: false,
              showClearFormat: false,
              showFontFamily: false,
              customButtons: [
                QuillToolbarCustomButtonOptions(
                    icon: Icon(Icons.close),
                    onPressed: () => controller.showToolBar.value = false)
              ]),
        ),
      ),
    );
  }
}
