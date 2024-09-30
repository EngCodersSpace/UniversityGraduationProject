import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/localization/arabic_language.dart';
import 'package:ibb_university_students_services/app/localization/english_language.dart';

class Languages implements Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys =>{
    'ar':Arabic().dictionary,
    'en':Engilsh().dictionary
  };


}