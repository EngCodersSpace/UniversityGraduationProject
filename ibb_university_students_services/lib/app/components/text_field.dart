// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.isPassword = false,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.icon,
    this.labelText,
    this.width,
    this.onTap,
    this.onTapOutside,
    this.focusNode,
    this.onFieldSubmitted,
    this.onSaved,
  });

  bool isPassword;
  RxBool hide = true.obs;
  TextEditingController? controller;
  IconData? icon;
  String? labelText;
  double? width;
  String? Function(String?)? validator;
  void Function()? onTap;
  void Function(PointerDownEvent)? onTapOutside;
  FocusNode? focusNode ;
  void Function(String?)? onSaved;
  void Function(String?)? onFieldSubmitted;
  bool readOnly;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: (isPassword)?Obx(()=>TextFormField(
        controller: controller,
        focusNode: focusNode,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        readOnly: readOnly,
        onTap: onTap,
        onTapOutside: onTapOutside,
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
        focusNode: focusNode,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        readOnly: readOnly,
        onTap: onTap,
        onTapOutside: onTapOutside,
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
