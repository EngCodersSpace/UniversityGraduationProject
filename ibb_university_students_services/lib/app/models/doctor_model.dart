import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

class Doctor extends User {

  RxString? academicDegree;
  RxString? administrativePosition;


  Doctor({
    required super.id,
    super.name,
    super.email,
    super.phone,
    super.profileImage,
    super.department,
    this.academicDegree,
    this.administrativePosition,
    super.createdAt,
    super.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: RxInt(json['id'] ?? 0),
      name: RxString(json['name'] ?? ""),
      email: RxString(json['email'] ?? ""),
      phone: RxString(json['phone'] ?? ""),
      profileImage: RxString(json['profile_image'] ?? ""),
      department: RxString(json['department'] ?? ""),
      academicDegree: RxString(json['academic_degree'] ?? ""),
      administrativePosition: RxString(json['administrative_position'] ?? ""),
      createdAt: RxString(json['created_at'] ?? ""),
      updatedAt: RxString(json['updated_at'] ?? ""),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "name": name?.value,
      "email": email?.value,
      "phone": phone?.value,
      "department": department?.value,
      "academic_degree": academicDegree?.value,
      "administrative_position": administrativePosition?.value,
      "profile_image": profileImage?.value,
      "created_at": createdAt?.value,
      "updated_at": updatedAt?.value,
    };
  }

}
