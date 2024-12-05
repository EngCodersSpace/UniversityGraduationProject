import 'package:dio/dio.dart';
import '../models/days_table.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';


class LectureServices {
  static const int  _fetchError = 611;

  static Map<String,Map<String,Map<String,dynamic>?>?>? _lectures;

  static Future<Result<Map>> fetchTableTime({
    required int sectionId,
    required int levelId,
    required String year,
    int? term,
    bool hardFetch = false,
  }) async {
    if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year] != null && !hardFetch && term == null) {
      if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year][term] != null && term !=null) {
        return Result(
          data: _lectures?[sectionId.toString()]?[levelId.toString()]?[year][term],
          statusCode: 200,
          hasError: false,
          message: "successful",
        );
      }
      return Result(
        data: _lectures?[sectionId.toString()]?[levelId.toString()]?[year],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("lectures/$sectionId/$levelId/$year");
      if (response?.statusCode == 200) {
        _lectures ??= {};
        if(_lectures?[sectionId.toString()] == null){
          _lectures?[sectionId.toString()] = {};
        }
        if(_lectures?[sectionId.toString()]?[levelId.toString()] == null){
          _lectures?[sectionId.toString()]?[levelId.toString()] = {};
        }
        if(_lectures?[sectionId.toString()]?[levelId.toString()]?[year] == null){
          _lectures?[sectionId.toString()]?[levelId.toString()]?[year] = {};
        }


        for(String term in (response?.data["data"] as Map).keys){
            _lectures?[sectionId.toString()]?[levelId.toString()]?[year][term] = TableDays.fromJson(response?.data["data"][term]);
        }

        return Result(
            data: _lectures?[sectionId.toString()]?[levelId.toString()]?[year],
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





}
