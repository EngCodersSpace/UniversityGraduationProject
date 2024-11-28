// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../globals.dart';
import 'custom_text.dart';

class NewsCard extends StatelessWidget {
  NewsCard({
    required this.height,
    required this.width,
    this.text = "Title and description of the news",
    super.key,
  });

  String text;
  ImageProvider image = const AssetImage(
      "assets/images/login_background_0.jpg");
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height -30,
            decoration: BoxDecoration(
              color: AppColors.inverseCardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black38,
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 2)
                )
              ]
            ),
          ),
          Container(
            height: height -33,
            width: width -3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image:  DecorationImage(
                  image: image,
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            height: height -30,
            decoration: BoxDecoration(
              color: AppColors.coverColor,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: width * 0.1,
                    right: width * 0.2),
                child:
                MainText(text),
              )),
        ],
      ),
    );
  }
}
