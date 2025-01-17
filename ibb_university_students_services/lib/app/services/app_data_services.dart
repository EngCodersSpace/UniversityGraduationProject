import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/services/level_services.dart';
import 'package:ibb_university_students_services/app/services/section_services.dart';
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import '../models/helper_models/result.dart';
import '../models/level_model/level.dart';
import '../models/subject_model/subject_model.dart';
import 'http_provider/http_provider.dart';

class AppDataServices {
  static const int _fetchError = 611;



  static Future<Result<bool>> fetchAppData() async {
    late Response? response;
    try {
      response = await HttpProvider.get("all-data");
      if (response?.statusCode == 200) {
        Map<String,Subject> subjects = {};

        for (Map<String, dynamic> jsSubject in response?.data["data"]["subjects"]) {
          subjects[jsSubject["subject_id"]]=Subject.fromJson(jsSubject);
        }
        SubjectServices.cacheSubjects(subjects);


        Map<int,Section> sections = {};
        for (Map<String, dynamic> jsSection in response?.data["data"]["sections"]) {
          sections[jsSection["id"]]=Section.fromJson(jsSection);
        }
        SectionServices.cacheSections(sections);
        Map<int,Level> levels = {};
        for (Map<String, dynamic> jsLevel in response?.data["data"]["levels"]) {

          levels[jsLevel["id"]]= Level.fromJson(jsLevel);
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


}
