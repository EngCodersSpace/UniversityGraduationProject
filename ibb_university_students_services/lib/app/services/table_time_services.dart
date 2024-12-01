import 'package:dio/dio.dart';
import '../models/days_table.dart';
import '../models/result.dart';
import '../models/student_model.dart';
import 'http_provider/http_provider.dart';


class TableTimeServices {
  static const int  _fetchError = 611;

  static Map<String,Map<String,Map<String,dynamic>?>?>? _lectures;

  static Future<Result<Map>> fetchTableTime({
    required int sectionId,
    required int levelId,
    required String year,
    int? term,
    bool hardFetch = false,
  }) async {
    if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year] != null && !hardFetch) {

      return Result(
        data: null,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("lectures/lectures/$sectionId/$levelId/$year");
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




  ////////////////////////////////////////////////////////////////////////////////////////////
  //////                                     fake data                                 ///////
  ////////////////////////////////////////////////////////////////////////////////////////////
  static Future<Result<Student>> _fakeFetchTableTime({bool hardFetch = false}) async {
    // virtual response for test
    Map<String, dynamic> response = {
      'sun': [
        {
          "title": "AI",
          "startTime": "8:00",
          "endTime": "10:00",
          "doctor": "Farhan",
          "hall": "h1",
          "description": null
        },
        {
          "title": "Math",
          "startTime": "10:00",
          "endTime": "12:00",
          "doctor": "Hameed",
          "hall": "h1",
          "description": null,
          "canceled": true,
        }
      ],
      'mon': [
        {
          "title": "English",
          "startTime": "8:30",
          "endTime": "10:30",
          "doctor": "Ahmed",
          "hall": "h1",
          "description": null
        }
      ],
      'tue': [
        {
          "title": "AI",
          "startTime": "8:00",
          "endTime": "10:00",
          "doctor": "Farhan",
          "hall": "h1",
          "description": null
        },
        {
          "title": "Math",
          "startTime": "10:00",
          "endTime": "12:00",
          "doctor": "Hameed",
          "hall": "h1",
          "description": null,
          "canceled": true,
        },
        {
          "title": "Math",
          "startTime": "12:00",
          "endTime": "02:00",
          "doctor": "Hameed",
          "hall": "h1",
          "description": null,
          "canceled": true,
        }
      ],
      'wed': [],
      'the': [],
      'sat': [],
    };
    return Result(hasError: true, message: "error");
  }

}
