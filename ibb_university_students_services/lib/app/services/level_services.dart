import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import '../models/helper_models/result.dart';
import 'http_provider/http_provider.dart';


class LevelServices {
  static const int _fetchError = 611;

  static Map<int,Level>? _levels;

  static Future<Result<Map<int,Level>>> fetchLevels({
    bool hardFetch = false,
  }) async {
    if (_levels  != null &&
        !hardFetch) {
      return Result(
        data: _levels!,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-all-levels");
      if (response?.statusCode == 200) {
        _levels = {};
        for (Map<String, dynamic> jsLevel in response?.data["data"]["levels"]) {
          Level level = Level.fromJson(jsLevel);
          _levels?[level.id]= level;
        }
        return Result(
            data: _levels,
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
    _levels = levels;
  }

}