import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/localization/languages.dart';
import 'package:ibb_university_students_services/app/routes.dart';
import 'package:ibb_university_students_services/app/services/http_provider/http_provider.dart';
import 'package:ibb_university_students_services/app/services/app_data_services.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // HttpProvider.init(baseUrl: "http://192.168.0.31:3000/");
  HttpProvider.init(baseUrl: "http://192.168.43.135:3000/");
  await AppDataServices.fetchAppData();
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







