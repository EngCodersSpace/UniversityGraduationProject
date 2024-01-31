// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.isPassword = false,
    this.controller,
    this.validator,
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
  String? Function(String?)? validator;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: (isPassword)?Obx(()=>TextFormField(
        controller: controller,
        obscureText:  hide.value,
        validator: validator,
        decoration: InputDecoration(
            isDense: true,
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
        validator: validator,
        decoration: InputDecoration(
            isDense: true,
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
