// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.isPassword = false,
    this.controller,
    this.icon,
    this.labelText,
    this.width,
  });

  bool isPassword;
  RxBool hide = true.obs;
  TextEditingController? controller;
  IconData? icon;
  String? labelText;
  double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: (isPassword)?Obx(()=>TextFormField(
        controller: controller,
        obscureText:  hide.value,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            icon: Icon(
              icon,
              size: 40,
            ),

            labelText: labelText,
            suffixIcon:Obx((){
              return GestureDetector(
                child: Icon((hide.value)
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onTap: () {
                  hide.value = !hide.value;
                },
              );
            })
        ),
      )):
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            icon: Icon(
              icon,
              size: 40,
            ),
            labelText: labelText,

        ),
      ),
    );
  }
}
