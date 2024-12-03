import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';
import 'package:ibb_university_students_services/app/services/level_services.dart';
import 'package:ibb_university_students_services/app/services/section_services.dart';
import '../models/lavel_model.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';

class AppDataServices {
  static const int _fetchError = 611;

  static List<String>? _years  ;

  static Future<Result<bool>> fetchAppData() async {
    late Response? response;
    try {
      response = await HttpProvider.get("all-data");
      if (response?.statusCode == 200) {
        List<Section> sections = [];
        for (Map<String, dynamic> section in response?.data["data"]["sections"]) {
          sections.add(Section.fromJson(section));
        }
        SectionServices.cacheSections(sections);
        List<Level> levels = [];
        for (Map<String, dynamic> level in response?.data["data"]["levels"]) {
          levels.add(Level.fromJson(level));
        }
        LevelServices.cacheLevels(levels);
        return Result(
            data: true,
            hasError: true,
            statusCode: response?.statusCode ?? _fetchError,
            message: response?.data["message"] ?? "error");
      }

      return Result(
          data: false,
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

  static Future<Result<List<String>>> fetchLectureYears({
    bool hardFetch = false,
}) async {

    if (_years  != null &&
        !hardFetch) {
      return Result(
        data: _years,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("lecture/year");
      if (response?.statusCode == 200) {
         _years = response?.data["data"];
        return Result(
            data: _years,
            hasError: true,
            statusCode: response?.statusCode ?? _fetchError,
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
