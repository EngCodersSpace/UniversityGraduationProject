// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.isPassword = false,
    this.style,
    this.labelStyle,
    this.readOnly = false,
    this.enable,
    this.minLines,
    this.maxLines,
    this.controller,
    this.validator,
    this.icon,
    this.color = Colors.black,
    this.labelText,
    this.width,
    this.onTap,
    this.onTapOutside,
    this.focusNode,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChange,
    this.keyboardType,
    this.prefixIcon,
  }){
    labelStyle??=AppTextStyles.highlightStyle(textHeader: AppTextHeaders.h4);
  }

  bool isPassword;
  bool readOnly;
  RxBool hide = true.obs;
  bool? enable;
  int? minLines;
  int? maxLines;
  double? width;
  TextEditingController? controller;
  IconData? icon;
  String? labelText;
  FocusNode? focusNode;
  IconData? prefixIcon;
  Color color;
  TextInputType? keyboardType;
  TextStyle? style;
  TextStyle? labelStyle;

  String? Function(String?)? validator;
  void Function()? onTap;
  void Function(PointerDownEvent)? onTapOutside;
  void Function(String?)? onSaved;
  void Function(String?)? onFieldSubmitted;
  void Function(String?)? onChange;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: (isPassword)
          ? Obx(() => TextFormField(

                controller: controller,
                style: style,
                enabled: enable,
                readOnly: readOnly,
                keyboardType: keyboardType,
                focusNode: focusNode,
                onSaved: onSaved,
                onChanged: onChange,
                onFieldSubmitted: onFieldSubmitted,
                onTap: onTap,
                onTapOutside: onTapOutside,
                obscureText: hide.value,
                validator: validator,
                decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color,),
                        borderRadius: const BorderRadius.all(Radius.circular(25))),
                    border:  OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                        borderRadius: const BorderRadius.all(Radius.circular(30)),

                    ),
                    prefixIcon: (prefixIcon!=null)?Icon(prefixIcon):null,
                    prefixIconColor: color,
                    iconColor: color,
                    icon: (icon != null)
                        ? Icon(
                            icon,
                            size: 40,
                            color: color,
                          )
                        : null,
                    labelText: labelText,
                    labelStyle: labelStyle,
                    suffixIcon: Obx(() {
                      return GestureDetector(
                        child: Icon((hide.value)
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onTap: () {
                          hide.value = !hide.value;
                        },
                      );
                    })),
              ))
          : TextFormField(
              controller: controller,
              style: style,
              readOnly: readOnly,
              keyboardType: keyboardType,
              focusNode: focusNode,
              enabled: enable,
              minLines: minLines,
              maxLines: minLines ?? 1,
              onSaved: onSaved,
              onChanged: onChange,
              onFieldSubmitted: onFieldSubmitted,
              onTap: onTap,
              onTapOutside: onTapOutside,
              validator: validator,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color,),
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                border:  OutlineInputBorder(
                    borderSide: BorderSide(color: color,),
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                  prefixIcon: (prefixIcon!=null)?Icon(prefixIcon):null,
                prefixIconColor: color,
                iconColor: color,
                icon: (icon != null)
                    ? Icon(
                        icon,
                        size: 40,
                      )
                    : null,
                labelText: labelText,
                labelStyle: labelStyle,
              ),
            ),
    );
  }
}
