import 'package:hive/hive.dart';
import '../../domain/entity/entity.dart';

part 'UserModel.g.dart'; // Make sure this line is present

@HiveType(typeId: 32)
class UserModel extends User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String? profilePhotoUrl; // Nullable field

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhotoUrl,
  }) : super(id: id, name: name, email: email, phone: phone, profilePhotoUrl: profilePhotoUrl);

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profilePhotoUrl: json['profilePhoto'] ?? '', // Handle null values
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profilePhoto': profilePhotoUrl,
    };
  }
}
