import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/exam_model/exam_model.dart';
import 'package:ibb_university_students_services/app/models/grads_model/grads_model.dart';
import 'package:ibb_university_students_services/app/models/helper_models/lectures_cache/lectures_cache.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/models/study_plan_elements_model/study_plan_elements.dart';
import 'package:ibb_university_students_services/app/models/study_plan_model/study_plan_model.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/services/lecture_services.dart';
import 'package:ibb_university_students_services/app/services/section_services.dart';
import 'package:ibb_university_students_services/app/services/user_services.dart';

import '../level_services.dart';


class HiveServices{

  static registerAdapters() {
    Hive.registerAdapter(LevelAdapter());
    Hive.registerAdapter(SectionAdapter());
    Hive.registerAdapter(DoctorAdapter());
    Hive.registerAdapter(StudentAdapter());
    Hive.registerAdapter(InstructorAdapter());
    Hive.registerAdapter(SubjectAdapter());
    Hive.registerAdapter(ExamAdapter());
    Hive.registerAdapter(LectureAdapter());
    Hive.registerAdapter(GradAdapter());
    Hive.registerAdapter(StudentFeeAdapter());
    Hive.registerAdapter(StudyPlanElementAdapter());
    Hive.registerAdapter(StudyPlaneAdapter());
    Hive.registerAdapter(LecturesCacheAdapter());
  }
  static openGlobalBoxes()async{
    await UserServices.openBox();
    await LevelServices.openBox();
    await SectionServices.openBox();
    await LectureServices.openBox();
  }
}