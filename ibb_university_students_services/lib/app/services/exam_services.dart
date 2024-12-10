import 'package:dio/dio.dart';
import '../models/exam_model.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';


class ExamServices {
  static const int  _fetchError = 611;

  static Map<String,Map<String,Map<String,dynamic>?>?>? _exams;

  static Future<Result<List<Exam>>> fetchExams({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    bool hardFetch = false,
  }) async {
    if (_exams?[sectionId.toString()]?[levelId.toString()]?[year] != null && !hardFetch) {
      return Result(
        data: _exams?[sectionId.toString()]?[levelId.toString()]?[year][term],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-exam-grouped/$sectionId/$levelId/$year");
      if (response?.statusCode == 200) {
        _exams ??= {};
        if(_exams?[sectionId.toString()] == null){
          _exams?[sectionId.toString()] = {};
        }
        if(_exams?[sectionId.toString()]?[levelId.toString()] == null){
          _exams?[sectionId.toString()]?[levelId.toString()] = {};
        }
        if(_exams?[sectionId.toString()]?[levelId.toString()]?[year] == null){
          _exams?[sectionId.toString()]?[levelId.toString()]?[year] = {};
        }
        for(String term in (response?.data["data"] as Map).keys){
           List<Exam> exams = [];
          for(Map<String,dynamic> exam in response?.data["data"][term]){
            exams.add(Exam.fromJson(exam));
          }
          _exams?[sectionId.toString()]?[levelId.toString()]?[year][term] = exams;
        }
        return Result(
            data: _exams?[sectionId.toString()]?[levelId.toString()]?[year][term],
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
