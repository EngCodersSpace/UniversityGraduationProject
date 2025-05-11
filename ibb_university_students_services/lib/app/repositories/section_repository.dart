import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class SectionRepository {
  static const int _fetchError = 611;

  static Box<Section>? _sectionsBox;

  static Future<void> openBox() async {
    _sectionsBox = await Hive.openBox<Section>('sectionBox');
    // Box  = await Hive.openBox('');
  }

  static Future<void> clearBox() async {
    _sectionsBox = await Hive.openBox<Section>('sectionBox');
    _sectionsBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_sectionsBox?.isOpen ?? false) {
      await _sectionsBox?.close();
    }
  }

  static Future<Result<Map<int, Section>>> fetchSections({
    bool hardFetch = false,
  }) async {
    if ((_sectionsBox?.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
        data: (_sectionsBox?.toMap().cast<int, Section>()),
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
            data: (_sectionsBox?.toMap().cast<int, Section>()),
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
