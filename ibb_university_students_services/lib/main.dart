import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
      GetPlatform.isIOS
      //IOS UI
          ? GetCupertinoApp(
        title: "StudentServices",
        initialRoute: "/login",
        getPages: AppRoutes.routes,
      )
      // Android and web UI
      : GetMaterialApp(
      title: "StudentServices",
      initialRoute: "/login",
      getPages: AppRoutes.routes,
    );
  }
}





