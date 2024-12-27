import 'package:dio/dio.dart';
import '../models/exam_model.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';


class ExamServices {
  static const int  _fetchError = 621;
  static const int _createError = 622;

  static Map<String,Map<String,Map<int,Exam>?>?>? _exams;

  static Future<Result<List<Exam>>> fetchExams({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    bool hardFetch = false,
  }) async {
    if (_exams?[sectionId.toString()]?[levelId.toString()] != null && !hardFetch) {
      return Result(
        data: _exams?[sectionId.toString()]?[levelId.toString()]?.values.toList(),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-exam-grouped/$sectionId/$levelId");
      if (response?.statusCode == 200) {
        _exams ??= {};
        if(_exams?[sectionId.toString()] == null){
          _exams?[sectionId.toString()] = {};
        }
        if(_exams?[sectionId.toString()]?[levelId.toString()] == null){
          _exams?[sectionId.toString()]?[levelId.toString()] = {};
        }
        for(Map<String,dynamic> jsExam in response?.data["data"]["Term 1"]){
          Exam exam = Exam.fromJson(jsExam);
          _exams?[sectionId.toString()]?[levelId.toString()]?[exam.id] = exam;
          print("here");
        }
        return Result(
            data: _exams?[sectionId.toString()]?[levelId.toString()]?.values.toList(),
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


  static Future<Result<Exam>> createExam({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    required data,
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
    //   "subject_id": "adfero-neq",
    // "exam_section_id":3 ,
    // "exam_level_id": 3,
    // "exam_term": "Term 2",
    // "exam_year": "2024",
    // "exam_date": "2024-11-01",
    // "exam_time": "10:00:00",
    // "exam_day": "Wednesday",
    // "exam_room": "Hall 75"
      response = await HttpProvider.post(
          "create-exam",data: data);
      if (response?.statusCode == 200) {

      }
      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _createError,
          message: error.toString(),
          data: null);
    }
  }





}
