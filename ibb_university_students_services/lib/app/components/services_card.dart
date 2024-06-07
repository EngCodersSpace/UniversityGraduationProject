// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';

class ServicesCard extends GetView {
  ServicesCard(
      {super.key, this.size = 50, this.color, this.child, this.onTap}) {
    color ??= AppColors.inverseCardColor;
  }

  Widget? child;
  double size;
  Color? color;
  void Function()? onTap = () {};

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 24,
      surfaceTintColor: color,
      color: color,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
