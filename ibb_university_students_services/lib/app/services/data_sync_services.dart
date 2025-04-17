import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import 'package:ibb_university_students_services/app/models/data_sync/data_sync.dart';
import 'package:ibb_university_students_services/app/repositories/assignments_repository.dart';
import 'package:ibb_university_students_services/app/repositories/data_sync_repository.dart';
import 'package:ibb_university_students_services/app/repositories/exam_repository.dart';
import 'package:ibb_university_students_services/app/repositories/lecture_repository.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';

class DataSyncServices{

static Future<void> startSync()async{
 Map<String,DataSync> lastDataSyncs = await DataSyncRepository.fetchLastDataSyncs().then((e)=>e.data??{});
  DataSyncRepository.openBox();
  for(DataSync dataSync in lastDataSyncs.values){
   switch(dataSync.target){
    case "L":
     break;
    case "assignment":
     await syncAssignments(dataSync);
     break;
    case "lecture":
     await syncLectures(dataSync);
     break;
    case "exam":
     await syncExams(dataSync);
     break;
   }
  }
  DataSyncRepository.closeBox();
}

static Future<void> syncExams(DataSync dataSync)async {
 DataSync oldDataSync = await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id).then((e)=>e.data);
 if(DateTimeUtils.stringDataIsAfter(dataSync.updatedAt??"", oldDataSync.updatedAt??"")){
  if(dataSync.filters?["section_id"] == null||dataSync.filters?["level_id"])return;
  ExamRepository.fetchExamsGroup(sectionId: dataSync.filters?["section_id"], levelId: dataSync.filters?["level_id"],hardFetch: true);
 }
}

static Future<void> syncLectures(DataSync dataSync)async {
 DataSync oldDataSync = await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id).then((e)=>e.data);
 if(DateTimeUtils.stringDataIsAfter(dataSync.updatedAt??"", oldDataSync.updatedAt??"")){
  if(dataSync.filters?["section_id"] == null||dataSync.filters?["level_id"])return;
  LectureRepository.fetchTableTime(sectionId: dataSync.filters?["section_id"], levelId: dataSync.filters?["level_id"],hardFetch: true,);
  if (Get.isRegistered<LectureController>()){
   Get.find<LectureController>().refresh(force: false);
  }
 }
}

static Future<void> syncAssignments(DataSync dataSync)async {
 DataSync oldDataSync = await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id).then((e)=>e.data);
 if(DateTimeUtils.stringDataIsAfter(dataSync.updatedAt??"", oldDataSync.updatedAt??"")){
  if(dataSync.filters?["section_id"] == null||dataSync.filters?["level_id"]||dataSync.filters?["subject_id"])return;
  AssignmentsRepository.fetchAssignmentsGroup(sectionId: dataSync.filters?["section_id"], levelId: dataSync.filters?["level_id"],hardFetch: true, subjectId: dataSync.filters?["subject_id"],year: '');
  if (Get.isRegistered<AssignmentsTabController>()){
   Get.find<AssignmentsTabController>().refresh(force: false);
  }
 }
}

}