
class StudentFee {
  int id;
  int? studentId;
  int? sectionId;
  int? levelId;
  int? term;
  int? totalAmount;
  int? payedAmount;
  int? remainAmount;
  String? paymentState;
  String? paymentDate;
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




