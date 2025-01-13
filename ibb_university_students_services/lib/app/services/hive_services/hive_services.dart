import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';


class HiveServices{

  static registerAdapters() {
    Hive.registerAdapter(LevelAdapter());
    Hive.registerAdapter(SectionAdapter());
    Hive.registerAdapter(DoctorAdapter());
    Hive.registerAdapter(StudentAdapter());
    // Hive.registerAdapter(CatAdapter());
  }
}