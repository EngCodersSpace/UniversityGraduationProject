import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

class Student extends User {

  RxString? level;
  RxString? department;
  RxString? division;

  Student({
    required super.id,
    super.name,
    super.email,
    super.phone,
    super.profileImage,
    this.level,
    this.department,
    this.division,
    super.createdAt,
    super.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: RxInt(json['id'] ?? 0),
      name: RxString(json['name'] ?? ""),
      email: RxString(json['email'] ?? ""),
      phone: RxString(json['phone'] ?? ""),
      profileImage: RxString(json['profile_image'] ?? ""),
      level: RxString(json['level'] ?? ""),
      department: RxString(json['department'] ?? ""),
      division: RxString(json['division'] ?? ""),
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
      "level": level?.value,
      "department": department?.value,
      "division": division?.value,
      "profile_image": profileImage?.value,
      "created_at": createdAt?.value,
      "updated_at": updatedAt?.value,
    };
  }

}
