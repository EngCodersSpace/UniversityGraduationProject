import 'package:hive/hive.dart';

part 'student_fee.g.dart';
@HiveType(typeId: 11)
class StudentFee {
  @HiveField(0)
  int id;
  @HiveField(1)
  int? studentId;
  @HiveField(2)
  int? sectionId;
  @HiveField(3)
  int? levelId;
  @HiveField(4)
  int? term;
  @HiveField(5)
  int? totalAmount;
  @HiveField(6)
  int? payedAmount;
  @HiveField(7)
  int? remainAmount;
  @HiveField(8)
  String? paymentState;
  @HiveField(9)
  String? paymentDate;
  @HiveField(10)
  String? receiptNumber;

  StudentFee({
    required this.id,
    this.levelId,
    this.sectionId,
    this.term,
    this.studentId,
    this.totalAmount,
    this.payedAmount,
    this.remainAmount,
    this.paymentState,
    this.paymentDate,
    this.receiptNumber,
  });

  factory StudentFee.fromJson(Map<String, dynamic> json) {
    return StudentFee(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }

}




