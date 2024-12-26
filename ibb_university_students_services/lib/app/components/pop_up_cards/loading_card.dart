import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../styles/app_colors.dart';
import '../buttons.dart';
import '../custom_text.dart';

// ignore: must_be_immutable
class PopUpLoadingCard extends StatelessWidget {

  const PopUpLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Hero(
              tag: "LoadingPupCard",
              child: CircularProgressIndicator(
                color: Colors.lightBlueAccent,
              ))),
    );
  }
}
