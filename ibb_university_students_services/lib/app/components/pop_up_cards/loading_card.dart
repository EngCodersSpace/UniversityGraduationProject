import 'package:flutter/material.dart';
import 'package:get/get.dart';


// ignore: must_be_immutable
class PopUpLoadingCard extends GetView {

  const PopUpLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(
            color: Colors.lightBlueAccent,
          )),
    );
  }
}
