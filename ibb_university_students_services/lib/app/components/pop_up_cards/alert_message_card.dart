import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import '../buttons.dart';
import '../custom_text.dart';

// ignore: must_be_immutable
class PopUpAlertCard extends StatelessWidget {
  String massage = "";
  IconData icon = Icons.info_outline;

  PopUpAlertCard(this.massage, this.icon, {super.key});

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
                shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 3, color: AppColors.inverseCardColor),
                    borderRadius: BorderRadius.circular(32)),
                child: SizedBox(
                    width: double.maxFinite,
                    child: SafeArea(
                        minimum: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainText("Alert",
                                    textColor: AppColors.secTextColor),
                                Icon(
                                  icon,
                                  color: AppColors.inverseIconColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SecText(massage,
                                  textColor: AppColors.secTextColor),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomButton(
                                  onPress: () {
                                    Get.back(result: true);
                                  },
                                  text: "Ok",
                                ),
                              ],
                            )
                          ],
                        ))),
              ))),
    );
  }
}