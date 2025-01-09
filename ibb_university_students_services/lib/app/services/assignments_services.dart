import 'package:ibb_university_students_services/app/services/subject_services.dart';
import '../models/assignment_model.dart';
import '../models/result.dart';
import '../models/subject_model.dart';

class AssignmentsServices {
  // static const int _fetchAllError = 621;
  // static const int _fetchError = 622;
  // static const int _createError = 623;
  // static const int _updateError = 624;
  // static const int _deleteError = 625;

  static Map<String, Map<int, Assignment>?>? _assignments;

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
// fake data

  static Future<Result<Map<int, Assignment>?>> fetchFakeAssignments({
    required String subjectId,
    bool hardFetch = false,
  }) async {
    if (_assignments?[subjectId] != null && !hardFetch) {
      return Result(
          data: _assignments?[subjectId],
          statusCode: 200,
          hasError: false,
          message: "successful",);
    }
    for (String jsSubjectId in fakeAssignments.keys) {
      Subject? subject =
          await SubjectServices.fetchSubject(id: jsSubjectId).then((e) {
        return e.data;
      });

      for (Map<String, dynamic> jsAssignment
          in fakeAssignments[jsSubjectId] ?? []) {
        Assignment assignment =
            Assignment.fromJson(jsAssignment, subject: subject);
        _assignments?[jsSubjectId]?[assignment.id] = assignment;
      }
    }
    return Result(
      data: _assignments?[subjectId],
      statusCode: 200,
      hasError: false,
      message: "successful",
    );
  }

  static Future<Result<List<String>>> fetchFakeAssignmentsSubjects(
      {bool hardFetch = false}) async {
    if (_assignments != null && !hardFetch) {
      return Result(
        data: _assignments?.keys.toList() ?? [],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    _assignments = {};
    for (String jsSubjectId in fakeAssignments.keys) {
      Subject? subject =
          await SubjectServices.fetchSubject(id: jsSubjectId).then((e) {
        return e.data;
      });
      _assignments?[jsSubjectId] = {};
      for (Map<String, dynamic> jsAssignment
          in fakeAssignments[jsSubjectId] ?? []) {
        Assignment assignment =
            Assignment.fromJson(jsAssignment, subject: subject);
        _assignments?[jsSubjectId]?[assignment.id] = assignment;
      }
    }
    return Result(
      data: _assignments?.keys.toList() ?? [],
      statusCode: 200,
      hasError: false,
      message: "successful",
    );
  }

  static Map<String, List<Map<String, dynamic>>> fakeAssignments = {
    "aqua-volut": [
      {
        "id": 1,
        "subject_id": "aqua-volut",
        "doctor_id": 1,
        "title": "Renewable Energy Assignment 1",
        "assignment_day": "Monday",
        "assignment_date": "2024-02-01",
        "assignments_due_date": "2024-02-08",
        "attachment": "renewable_energy_intro.pdf"
      },
      {
        "id": 2,
        "subject_id": "aqua-volut",
        "doctor_id": 1,
        "title": "Renewable Energy Case Study",
        "assignment_day": "Tuesday",
        "assignment_date": "2024-02-02",
        "assignments_due_date": "2024-02-09",
        "attachment": "renewable_case_study.pdf"
      },
      {
        "id": 3,
        "subject_id": "aqua-volut",
        "doctor_id": 1,
        "title": "Renewable Energy Lab Task",
        "assignment_day": "Wednesday",
        "assignment_date": "2024-02-03",
        "assignments_due_date": "2024-02-10",
        "attachment": "renewable_lab_task.pdf"
      }
    ],
    "arto-cura-": [
      {
        "id": 4,
        "subject_id": "arto-cura-",
        "doctor_id": 2,
        "title": "Materials Science Homework",
        "assignment_day": "Thursday",
        "assignment_date": "2024-02-04",
        "assignments_due_date": "2024-02-11",
        "attachment": "materials_science_lab.docx"
      },
      {
        "id": 5,
        "subject_id": "arto-cura-",
        "doctor_id": 2,
        "title": "Materials Science Group Project",
        "assignment_day": "Saturday",
        "assignment_date": "2024-02-06",
        "assignments_due_date": "2024-02-13",
        "attachment": "materials_group_project.pdf"
      }
    ],
    "cavus-inci": [
      {
        "id": 6,
        "subject_id": "cavus-inci",
        "doctor_id": 3,
        "title": "Embedded Systems Design Task",
        "assignment_day": "Sunday",
        "assignment_date": "2024-02-07",
        "assignments_due_date": "2024-02-14",
        "attachment": "embedded_design_task.pdf"
      }
    ],
    "clementia-": [
      {
        "id": 7,
        "subject_id": "clementia-",
        "doctor_id": 4,
        "title": "Advanced Mechanics Problem Set",
        "assignment_day": "Monday",
        "assignment_date": "2024-02-08",
        "assignments_due_date": "2024-02-15",
        "attachment": "advanced_mechanics_set.docx"
      },
      {
        "id": 8,
        "subject_id": "clementia-",
        "doctor_id": 4,
        "title": "Advanced Mechanics Lab Task",
        "assignment_day": "Tuesday",
        "assignment_date": "2024-02-09",
        "assignments_due_date": "2024-02-16",
        "attachment": "advanced_mechanics_lab_task.pdf"
      }
    ],
    "creator-de": [
      {
        "id": 9,
        "subject_id": "creator-de",
        "doctor_id": 5,
        "title": "Fluid Mechanics Case Study",
        "assignment_day": "Wednesday",
        "assignment_date": "2024-02-10",
        "assignments_due_date": "2024-02-17",
        "attachment": "fluid_mechanics_case.pdf"
      }
    ],
    "creptio-se": [
      {
        "id": 10,
        "subject_id": "creptio-se",
        "doctor_id": 6,
        "title": "Power Systems Analysis Report",
        "assignment_day": "Thursday",
        "assignment_date": "2024-02-11",
        "assignments_due_date": "2024-02-18",
        "attachment": "power_systems_report.pdf"
      },
      {
        "id": 11,
        "subject_id": "creptio-se",
        "doctor_id": 6,
        "title": "Power Systems Simulation Task",
        "assignment_day": "Saturday",
        "assignment_date": "2024-02-12",
        "assignments_due_date": "2024-02-19",
        "attachment": "power_systems_simulation.pdf"
      }
    ],
    "CS101": [
      {
        "id": 12,
        "subject_id": "CS101",
        "doctor_id": 7,
        "title": "Introduction to CS Assignment",
        "assignment_day": "Sunday",
        "assignment_date": "2024-02-13",
        "assignments_due_date": "2024-02-20",
        "attachment": "cs101_assignment.pdf"
      },
      {
        "id": 13,
        "subject_id": "CS101",
        "doctor_id": 7,
        "title": "CS Group Discussion Task",
        "assignment_day": "Monday",
        "assignment_date": "2024-02-14",
        "assignments_due_date": "2024-02-21",
        "attachment": "cs_group_discussion.pdf"
      },
      {
        "id": 14,
        "subject_id": "CS101",
        "doctor_id": 7,
        "title": "CS Final Project",
        "assignment_day": "Tuesday",
        "assignment_date": "2024-02-15",
        "assignments_due_date": "2024-02-22",
        "attachment": "cs_final_project.pdf"
      }
    ]
  }
  ;
}
