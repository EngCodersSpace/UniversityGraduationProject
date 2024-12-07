import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_text.dart';
import '../../../styles/app_colors.dart';


// ignore: must_be_immutable
class PopUpBookInfoCard extends GetView<LibraryController> {

  // ignore: prefer_const_constructors_in_immutables
  PopUpBookInfoCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Hero(
              tag: "PupCard",
              child: Material(
                color: AppColors.mainCardColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.inverseCardColor,
                          width: 4
                      ),
                      borderRadius: BorderRadius.circular(32)
                  ),
                  height: Get.height*0.4,
                  width: Get.width - 32,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                              Icon(Icons.info_outline,color: AppColors.secTextColor,),
                              const SizedBox(width: 6,),
                              SecText("Book Information"),
                            ],),
                            IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.close,color: AppColors.secTextColor,))
                          ],
                        ),
                        Divider(
                          color: AppColors.inverseCardColor,
                          thickness: 2,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Image(image: AssetImage(controller.selectedBook["image"]??""),width: 160,),
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SecText("Name :${controller.selectedBook["name"]}"),
                                      SecText("Authors :"),
                                      SecText("Pages : "),
                                      SecText("Size :"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                        Divider(
                          color: AppColors.inverseCardColor,
                          thickness: 2,
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomButton(text:"Download",onPress: (){},size: const Size(120, 40),),
                                CustomButton(text:"View",onPress: (){},size: const Size(120, 40),),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
          )
      ),

    );

  }

}
