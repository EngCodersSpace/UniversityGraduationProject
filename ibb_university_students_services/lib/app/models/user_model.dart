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
}
