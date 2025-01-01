import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/grads_model.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';


class GradServices {
  static const int  _fetchError = 611;

  static Map<int,Map<int,Grad>>? _gradsByLevels;

  static Future<Result<List<Grad>>> fetchStudentGrads({
    required int levelId,
    required String? term,
    bool hardFetch = false,
  }) async {
    if (_gradsByLevels?[levelId] != null && (_gradsByLevels?[levelId]?.isNotEmpty??false) && !hardFetch){
      return Result(
        data: _gradsByLevels?[levelId]?.values.toList(),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {

      response = await HttpProvider.get("get-grades?levelID=$levelId&Term=$term");
      // print(response?.data);
      if (response?.statusCode == 200) {
        _gradsByLevels ??= {};
        _gradsByLevels?[levelId] = {};

        for(Map<String,dynamic> jsGrad in response?.data["Grades"]){
          // print("here");
          Grad grad = Grad.fromJson(jsGrad);

          _gradsByLevels?[levelId]?[grad.id] = grad;
        }

      }

      return Result(
          data: _gradsByLevels?[levelId]?.values.toList(),
          hasError: false,
          statusCode: response?.statusCode,
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
