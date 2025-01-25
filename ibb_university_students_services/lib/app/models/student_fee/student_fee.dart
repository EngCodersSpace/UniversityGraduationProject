import 'package:hive/hive.dart';

part 'student_fee.g.dart';

@HiveType(typeId: 11)
class StudentFee {
  @HiveField(0)
  int id;
  @HiveField(1)
  int? studentId;
  @HiveField(2)
  int? levelId;
  @HiveField(3)
  String? term;
  @HiveField(4)
  double? totalAmount;
  @HiveField(5)
  double? payedAmount;
  @HiveField(6)
  String? paymentDate;
  @HiveField(7)
  String? receiptNumber;

  StudentFee({
    required this.id,
    this.levelId,
    this.term,
    this.studentId,
    this.totalAmount,
    this.payedAmount,
    this.paymentDate,
    this.receiptNumber,
  });

  factory StudentFee.fromJson(Map<String, dynamic> json) {
    return StudentFee(
      id: json['id'],
      studentId: json['student_id'],
      levelId: json['level_fees_id'],
      term: json['term'],
      paymentDate: json['payment_date'],
      receiptNumber: json['receipt_number'],
      totalAmount: double.tryParse(json['total_amount']),
      payedAmount: double.tryParse(json['amount_paid']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "student_id": studentId,
      "level_fees_id": levelId,
      "term": term,
      "total_amount": totalAmount,
      "amount_paid": payedAmount,
      "payment_date": paymentDate,
      "receipt_number": receiptNumber
    };
  }
}
