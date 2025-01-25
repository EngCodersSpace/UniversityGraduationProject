import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';

part 'student_fee_cache.g.dart';
@HiveType(typeId: 23)
class StudentFeeCache {

  @HiveField(0)
  int key ;
  @HiveField(1)
  Map<int, StudentFee> data;


  StudentFeeCache({
    required this.key,
    required this.data,

  });
}
