// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../globals.dart';

class MainTab extends StatelessWidget {
  MainTab({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("home"),
          ],
        ));
  }
}
