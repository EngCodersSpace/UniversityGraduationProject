import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/localization/languages.dart';
import 'package:ibb_university_students_services/app/routes.dart';
import 'package:ibb_university_students_services/app/services/http_provider/http_provider.dart';


void main() {
  HttpProvider.init(baseUrl: "");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isIOS
        //IOS UI
        ? GetCupertinoApp(
            title: "StudentServices",
            initialRoute: "/login",
            translations: Languages(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en'),
            getPages: AppRoutes.routes,
            debugShowCheckedModeBanner: false,
          )
        // Android and web UI
        : GetMaterialApp(
            title: "StudentServices",
            initialRoute: "/login",
            translations: Languages(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en'),
            getPages: AppRoutes.routes,
            debugShowCheckedModeBanner: false,
          );

  }
}







