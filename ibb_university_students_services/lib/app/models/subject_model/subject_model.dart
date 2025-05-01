import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/utils/json_utils.dart';

import '../instructor_model/instructor_model.dart';

part 'subject_model.g.dart'; /// join this with SubjectAdapter class will be generate by hive

/// A Hive-adapted model representing a subject.
/// Includes translated fields and a map of nested instructor models.
///
@HiveType(typeId: 5) /// mark this class with unique id as DataType in hive.
class Subject {
  Subject({
    required this.id,
    this.subjectNameData,
    this.units,
    this.descriptionData,
    this.instructors,
  });

  /// Unique identifier of the subject
  @HiveField(0) /// this mark the fields and there index which be include on the Adapter
  String id;

  /// Stores translated subject names in JSON format (e.g., {'en': 'Math', 'ar': 'رياضيات'})
  @HiveField(1)
  Map<String, dynamic>? subjectNameData;

  @HiveField(2)
  int? units;

  /// Stores translated descriptions in JSON format
  @HiveField(3)
  Map<String, dynamic>? descriptionData;

  /// Holds nested instructor objects mapped by their IDs
  /// Instructor must also be Hive-compatible and registered with Hive
  @HiveField(4)
  Map<int, Instructor>? instructors;

  /// Computed getter returns the subject name in the current app language
  String? get subjectName {
    String currentLang = Get.locale?.languageCode.toString() ?? "en";
    return subjectNameData?[currentLang];
  }

  /// Computed getter returns the subject description in the current app language
  String? get description {
    String currentLang = Get.locale?.languageCode.toString() ?? "en";
    return descriptionData?[currentLang];
  }

  /// Parses a Subject from JSON (usually from the backend)
  factory Subject.fromJson(Map<String, dynamic> json) {
    Map<int, Instructor> instructors = {};

    // Extract and parse instructors from backend list
    for (Map<String, dynamic> instructor in (json["doctors"] ?? [])) {
      instructors[instructor["doctor_id"]] = Instructor.fromJson(instructor);
    }

    return Subject(
      id: json['subject_id'],
      subjectNameData: JsonUtils.tryJsonDecode(json['subject_name']),
      units: json['number_of_units'],
      instructors: instructors,
      descriptionData: JsonUtils.tryJsonDecode(json['subject_description']),
    );
  }

  String? get value => null;

  /// Converts the Subject instance to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      "subject_id": id,
      "subject_name": subjectName, // Returns localized string only
      "number_of_units": units,
      "doctors": instructors?.values.map((e) => e.toJson()).toList(),
      "subject_description": descriptionData,
    };
  }
}
