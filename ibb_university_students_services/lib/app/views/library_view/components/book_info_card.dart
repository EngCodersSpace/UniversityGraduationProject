import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_text.dart';
import '../../../globals.dart';


// ignore: must_be_immutable
class PopUpBookInfoCard extends GetView<LibraryController> {
  String massage = "";
  IconData icon = Icons.info_outline;

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
                child: SizedBox(
                  height: 350,
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.info_outline,color: AppColors.secTextColor,),
                            SecText("Book Information"),
                            IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.close,color: AppColors.secTextColor,))
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Image(image: AssetImage("assets/images/library/istockphoto-867895848-612x612.jpg"),),
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SecText("Name :"),
                                    SecText("Authors :"),
                                    SecText("Pages : "),
                                    SecText("Size :"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomButton(text:"Download",onPress: (){},size: Size(120, 40),),
                                CustomButton(text:"View",onPress: (){},size: Size(120, 40),),
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
