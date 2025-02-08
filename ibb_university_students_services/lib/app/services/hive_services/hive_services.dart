import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/assignment_model/assignment_model.dart';
import 'package:ibb_university_students_services/app/models/attachment_file_model/attachment_file_model.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/exam_model/exam_model.dart';
import 'package:ibb_university_students_services/app/models/grads_model/grads_model.dart';
import 'package:ibb_university_students_services/app/models/helper_models/assignments_cache/assignments_cache.dart';
import 'package:ibb_university_students_services/app/models/helper_models/exams_cache/exams_cache.dart';
import 'package:ibb_university_students_services/app/models/helper_models/lectures_cache/lectures_cache.dart';
import 'package:ibb_university_students_services/app/models/helper_models/student_assignment_state/student_assignment_state.dart';
import 'package:ibb_university_students_services/app/models/helper_models/students_fee_cache/student_fee_cache.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/student_assignments_file_model/student_assignments_file_model.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/models/study_plan_elements_model/study_plan_elements.dart';
import 'package:ibb_university_students_services/app/models/study_plan_model/study_plan_model.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/assignments_repository.dart';
import 'package:ibb_university_students_services/app/repositories/exam_repository.dart';
import 'package:ibb_university_students_services/app/repositories/lecture_repository.dart';
import 'package:ibb_university_students_services/app/repositories/student_fee_repository.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';

import '../../models/helper_models/subjects_cache/subjects_cache.dart';
import '../../repositories/level_repository.dart';
import '../../repositories/section_repository.dart';



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
    Hive.registerAdapter(StudentFeeCacheAdapter());
    Hive.registerAdapter(LecturesCacheAdapter());
    Hive.registerAdapter(ExamsCacheAdapter());
    Hive.registerAdapter(AssignmentsCacheAdapter());
    Hive.registerAdapter(SubjectsCacheAdapter());
    Hive.registerAdapter(AssignmentAdapter());
    Hive.registerAdapter(AttachmentFileAdapter());
    Hive.registerAdapter(StudentAssignmentsFileAdapter());
    Hive.registerAdapter(StudentAssignmentStateAdapter());
  }
  static openGlobalBoxes()async{
    await SubjectRepository.openBox();
    await UserRepository.openBox();
    await LevelRepository.openBox();
    await SectionRepository.openBox();
    await LectureRepository.openBox();
    await AssignmentsRepository.openBox();
  }

  static clearAllBox() async{
    await AssignmentsRepository.clearBox();
    await ExamRepository.clearBox();
    // await GradRepository.clearBox();
    await LectureRepository.clearBox();
    await LevelRepository.clearBox();
    // await NotificationRepository.clearBox();
    await SectionRepository.clearBox();
    await StudentFeeRepository.clearBox();
    await SubjectRepository.clearBox();
    await UserRepository.clearBox();

  }

  static closeAllBoxes() async{
    await AssignmentsRepository.closeBox();
    await ExamRepository.closeBox();
    // await GradRepository.closeBox();
    await LectureRepository.closeBox();
    await LevelRepository.closeBox();
    // await NotificationRepository.closeBox();
    await SectionRepository.closeBox();
    await StudentFeeRepository.closeBox();
    await SubjectRepository.closeBox();
    await UserRepository.closeBox();
  }
}