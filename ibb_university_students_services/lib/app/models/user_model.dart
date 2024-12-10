abstract class User {
  int id;
  String? name;
  String? dateOfBrith;
  String? email;
  String? permission;
  String? profileImage;
  List<String>? phones;
  String? createdAt;
  String? updatedAt;

  User({
    required this.id,
    this.name,
    this.dateOfBrith,
    this.email,
    this.permission,
    this.profileImage,
    this.phones,
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
