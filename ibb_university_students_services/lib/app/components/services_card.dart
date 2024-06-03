// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../globals.dart';

class ServicesCard extends StatelessWidget {
  ServicesCard({
    super.key,
    this.size=50,
    this.color,
    this.child,
  }){
   color??=AppColors.cardColor;
  }
  Widget? child;
  double size;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 24,
        surfaceTintColor:color,
        color: color,
        child: child,
      ),
    );
  }
}
