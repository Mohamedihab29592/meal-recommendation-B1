import '../../domain/entity/entity.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.profilePhotoUrl,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'],
      email: json['email'],
      phone: json['phoneNumber'],
      profilePhotoUrl: json['profile_pic'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phone,
      'profile_pic': profilePhotoUrl,
    };
  }
}
