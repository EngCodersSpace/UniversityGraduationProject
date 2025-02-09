import 'package:get/get.dart';

String mappingTerms(String? term,{String lang ='en'}){
  if(term == "Term 1") {
    return (lang=='en')?"1St":"الأول";
  } else if (term == "Term 2") {
    return (lang=='en')?"2ec":"الثاني";
  } else {
    return "Unknown";
  }
}

int termIndex(String? term){
  if(term == "Term 1") {
    return 0;
  } else if (term == "Term 2") {
    return 1;
  } else {
    return -1;
  }
}



String mappingStudentState(int repeatYears,){
  if(repeatYears>0){
    return "معيد";
  }else if (repeatYears == 0){
    return "مستجد";
  }else{
    return "Unknown".tr;
  }
}
