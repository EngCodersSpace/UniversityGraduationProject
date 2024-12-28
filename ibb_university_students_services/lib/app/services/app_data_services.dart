import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';
import 'package:ibb_university_students_services/app/models/subject_model.dart';
import 'package:ibb_university_students_services/app/services/level_services.dart';
import 'package:ibb_university_students_services/app/services/section_services.dart';
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import '../models/level_model.dart';
import '../models/result.dart';
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
          Subject subject = Subject.fromJson(jsSubject);
          subjects[subject.id]=subject;
        }
        SubjectServices.cacheSubjects(subjects);


        Map<int,Section> sections = {};
        for (Map<String, dynamic> jsSection in response?.data["data"]["sections"]) {
          Section section = Section.fromJson(jsSection);
          sections[section.id]=section;
        }
        SectionServices.cacheSections(sections);
        Map<int,Level> levels = {};
        for (Map<String, dynamic> jsLevel in response?.data["data"]["levels"]) {
          Level level = Level.fromJson(jsLevel);
          levels[level.id]= level;
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
