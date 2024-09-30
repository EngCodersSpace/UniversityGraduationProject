import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

class Doctor extends User {

  RxString? mmmm;


  Doctor({
    required super.id,
    super.name,
    super.email,
    super.phone,
    super.profileImage,
    this.mmmm,
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
      mmmm: RxString(json['level'] ?? ""),
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
      "mmmm": mmmm?.value,
      "profile_image": profileImage?.value,
      "created_at": createdAt?.value,
      "updated_at": updatedAt?.value,
    };
  }

}
