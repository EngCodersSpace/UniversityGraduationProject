//import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ibb_university_students_services/app/controllers/main_controller.dart';
// import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';

// import '../../components/custom_text.dart';
// import '../../globals.dart';
// import '../main_view/web_main_view.dart';
// import '../notification_tab_view/web_notification_view.dart';
// import '../profile_tab_view/web_profile_view.dart';
// import '../table_tab_view/web_table_tab_view.dart';

// // ignore: must_be_immutable
// class WebHomeTab extends GetView<HomeTabController> {
//   WebHomeTab({
//     super.key,
//   });
//   double hight = Get.height;
//   double width = Get.width;
//   late double cardsize = (width - width * 0.35);

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Obx(() =>(controller.initState.value)
//   ?SafeArea(
//     minimum: EdgeInsets.only(top:hight*0.3, ),
//     child: SingleChildScrollView(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding:  EdgeInsets.only(left: width*0.04, right: width*0.04),
//             child: Container(
//               width: 80,

//               color: Colors.blue[900],
//               child:Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 margin: EdgeInsets.all(5),

//               ),
//             ),
//           )
//         ],
//       ),

//     ),

//     )
//      );
//   }

  
// }
