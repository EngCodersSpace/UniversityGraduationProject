// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';

class ServicesCard extends GetView {
  ServicesCard(
      {super.key,
      this.size = 50,
      this.color,
      this.child,
      this.onTap,
      this.image}) {
    color ??= AppColors.inverseCardColor;
  }

  Widget? child;
  double size;
  Color? color;
  ImageProvider? image;
  void Function()? onTap = () {};

  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: color,
        color: color,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size - 4,
              width: size - 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  boxShadow:  [
                    BoxShadow(
                      color: AppColors.tabBackColor.withOpacity(1),
                        spreadRadius: 8,
                        blurRadius: 5,

                        offset: const Offset(0, 0)
                    )
                  ],
                image: (image != null)
                    ? DecorationImage(
                        image: image!,
                        fit: BoxFit.fill,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: size,
              width: size,
              child: InkWell(
                onTap: onTap,
                splashColor: AppColors.coverColor,
                child: child,
              ),
            )
          ],
        ));
  }
}
