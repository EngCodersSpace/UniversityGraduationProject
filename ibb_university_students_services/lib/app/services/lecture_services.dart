import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/lecture_model.dart';
import '../models/days_table.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';

class LectureServices {
  static const int _fetchError = 611;
  static const int _fetchYearsError = 612;

  static Map<
          String,
          Map<String,
              Map<String, Map<String, Map<String, Map<int, Lecture>>>?>?>?>?
      _lectures;
  static List<String>? _years;

  static Future<Result<TableDays>> fetchTableTime({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    bool hardFetch = false,
  }) async {
    if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year]?[term] !=
            null &&
        !hardFetch) {
      return Result(
        data: TableDays.fromJson(_lectures![sectionId.toString()]![
            levelId.toString()]![year]![term]!),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "lectures/grouped?section_id=$sectionId&level_id=$levelId&term=$term");
      if (response?.statusCode == 200) {
        _lectures ??= {};
        if (_lectures?[sectionId.toString()] == null) {
          _lectures?[sectionId.toString()] = {};
        }
        if (_lectures?[sectionId.toString()]?[levelId.toString()] == null) {
          _lectures?[sectionId.toString()]?[levelId.toString()] = {};
        }
        if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year] ==
            null) {
          _lectures?[sectionId.toString()]?[levelId.toString()]?[year] = {};
        }
        if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year]
                ?[term] ==
            null) {
          _lectures?[sectionId.toString()]?[levelId.toString()]?[year]
              ?[term] = {};
        }

        for (String term in (response?.data["data"] as Map).keys) {
          for (String day in (response?.data["data"][term] as Map).keys) {
            _lectures?[sectionId.toString()]?[levelId.toString()]?[year]
            ?[term]?[day] = {};
            for (Map<String, dynamic> jsLecture in response?.data["data"][term]
                [day]) {
              Lecture lecture = Lecture.fromJson(jsLecture);
              _lectures?[sectionId.toString()]?[levelId.toString()]?[year]
                  ?[term]?[day]?[lecture.id] = lecture;
            }
          }
        }
        if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year]
                ?[term] !=
            null) {
          print("here");
          return Result(
              data:  TableDays.fromJson(_lectures![sectionId.toString()]![
                  levelId.toString()]![year]![term]!),
              hasError: false,
              statusCode: response?.statusCode,
              message: response?.data["message"] ?? "error");
        }
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

  static Future<Result<List<String>>> fetchLectureYears({
    bool hardFetch = false,
  }) async {
    if (_years != null && !hardFetch) {
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
        _years = List<String>.from(response?.data["data"]);
        return Result(
            data: _years,
            hasError: true,
            statusCode: response?.statusCode ?? _fetchYearsError,
            message: response?.data["message"] ?? "error");
      }
      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchYearsError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchYearsError,
          message: error.toString(),
          data: null);
    }
  }
}
