import 'package:get/get_rx/src/rx_types/rx_types.dart';

class User {
  RxInt id;
  RxString? name;
  RxString? email;
  RxString? phone;
  RxString? department;
  RxString? profileImage;
  RxString? createdAt;
  RxString? updatedAt;

  User({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.department,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: RxInt(json['id']),
      name: RxString(json['name'] ?? ""),
      email: RxString(json['email'] ?? ""),
      phone: RxString(json['phone'] ?? ""),
      department: RxString(json['department'] ?? ""),
      profileImage: RxString(json['profileImage'] ?? ""),
      createdAt: RxString(json['created_at'] ?? ""),
      updatedAt: RxString(json['updated_at'] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "name": name?.value,
      "email": email?.value,
      "phone": phone?.value,
      "profile_image": profileImage?.value,
      "created_at": createdAt?.value,
      "updated_at": updatedAt?.value,
    };
  }

}




