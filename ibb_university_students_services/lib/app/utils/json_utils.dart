import 'dart:convert';
import 'package:flutter/foundation.dart';

class JsonUtils{
  static Map<String,dynamic>? tryJsonDecode(String jsonData){
    try{
      Map<String,dynamic> data = jsonDecode(jsonData);
      return data;
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
