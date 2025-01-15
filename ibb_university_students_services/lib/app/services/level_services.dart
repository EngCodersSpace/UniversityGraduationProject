import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import '../models/helper_models/result.dart';
import '../utils/internet_connection_cheker.dart';
import 'http_provider/http_provider.dart';


class LevelServices {
  static const int _fetchError = 611;

  static Box<Level>? _levelBox;

  static Future<void> openBox() async {
    _levelBox = await Hive.openBox<Level>('levelBox');
    // Box  = await Hive.openBox('');
  }

  static Future<void> closeBox() async {
    await _levelBox?.close();
  }

  static Future<Result<List<Level>>> fetchLevels({
    bool hardFetch = false,
  }) async {
    if ((_levelBox?.values.isNotEmpty??true) &&
        !hardFetch &&!(await checkInternetConnection())) {
      return Result(
        data: _levelBox?.values.toList()??[],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-all-levels");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsLevel in response?.data["data"]["levels"]) {
          Level level = Level.fromJson(jsLevel);
          await _levelBox?.put(level.id, level) ;
        }
        return Result(
            data:  _levelBox?.values.toList()??[],
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }

      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchError,
          message: error.toString(),
          data: null);
    }
  }


  static void cacheLevels(Map<int,Level> levels){
    _levelBox?.putAll(levels)  ;
  }

}