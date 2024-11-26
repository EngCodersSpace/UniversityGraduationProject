

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';

import '../globals.dart';
import '../models/table_time_model.dart';

class LectureCard extends StatelessWidget {

  TableDayContent? content;
  double height;

  LectureCard({
    required this.content,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.mainCardColor,
        border: Border(
          bottom: BorderSide(color: AppColors.inverseCardColor,width: 2,strokeAlign: 1),
          right: BorderSide(color: AppColors.inverseCardColor,width: 2,strokeAlign: 1),
          left: BorderSide(color: AppColors.inverseCardColor,width: 2,strokeAlign: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 5),
          )
        ],
        borderRadius:
        const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height*0.51,
            width: double.maxFinite,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.inverseCardColor,
              borderRadius:
              const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration:BoxDecoration(
                        color: AppColors.mainCardColor,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(32)),
                      ),
                      child: SecText("  ${content?.startTime} - ${content?.endTime}  "),
                    ),
                    Container(
                      decoration:BoxDecoration(
                        color:(content?.canceled?.value??false)?Colors.redAccent:Colors.greenAccent,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(32)),
                      ),
                      child: (content?.canceled?.value??false)?SecText("  canceled  "):SecText("  correct  "),
                    ),
                  ],
                ),
                MainText(content?.title.value??"Unknown".tr),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children:[SecText("Doctor: ",fontWeight: FontWeight.bold,fontSize: 19),SecText("Dr.${content?.doctor??"-------"}")],),
                    Row(children:[SecText("Hall: ",fontWeight: FontWeight.bold,fontSize: 19),SecText("${content?.hall??"-------"}")],),
              ],
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SecText("Description: ",fontWeight: FontWeight.bold,fontSize: 19),
                    SecText("${content?.description??"-------"}")
                  ],
                ),

          ]),)
        ],
      ),
    );
  }
}
