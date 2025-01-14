import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import '../models/helper_models/result.dart';
import 'http_provider/http_provider.dart';

class SectionServices {
  static const int _fetchError = 611;

  static Box<Section>? _sectionsBox;

  static Future<void> openBox() async {
    _sectionsBox = await Hive.openBox<Section>('sectionBox');
    // Box  = await Hive.openBox('');
  }

  static Future<void> closeBox() async {
    await _sectionsBox?.close();
  }

  static Future<Result<List<Section>>> fetchSections({
    bool hardFetch = false,
  }) async {
    if ((_sectionsBox?.isNotEmpty ?? false) && !hardFetch) {
      return Result(
        data: _sectionsBox?.values.toList(),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-all-sections");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsSection in response?.data["data"]
            ["sections"]) {
          Section section = Section.fromJson(jsSection);
          await _sectionsBox?.put(section.id, section);
        }
        return Result(
            data: _sectionsBox?.values.toList(),
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

  static void cacheSections(Map<int, Section> sections) async {
    await _sectionsBox?.putAll(sections);
  }
}
