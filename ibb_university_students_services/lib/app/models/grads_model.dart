class Grad {
  Grad({
    required this.id,
    this.subjectName,
    this.examGrad,
    this.workGrad
  });


  int id;
  String? subjectName;
  int? examGrad;
  int? workGrad;


  factory Grad.fromJson(Map<String, dynamic> json) {
    return Grad(
        id: json['id'],
        subjectName: json['subject_name'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject_name":subjectName,

    };
  }

}
