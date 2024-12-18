import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/grads_model.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';


class GradServices {
  static const int  _fetchError = 611;

  static Map<int,List<Grad>>? _levels;

  static Future<Result<List<Grad>>> fetchStudentGrads({
    required int levelId,
    required String? term,
    bool hardFetch = false,
  }) async {
    if (_levels?[levelId] != null && (_levels?[levelId]?.isNotEmpty??false) && !hardFetch){
      return Result(
        data: _levels?[levelId],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-grades?levelID=$levelId&Term=$term");
      if (response?.statusCode == 200) {
        _levels ??= {};
        _levels?[levelId] = [];
        for(Map<String,dynamic> grad in response?.data["Grades"]){
          _levels?[levelId]?.add(Grad.fromJson(grad));
        }

        return Result(
            data: null,
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
