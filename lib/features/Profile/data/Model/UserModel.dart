import 'package:hive/hive.dart';
import 'package:meal_recommendation_b1/features/auth/login/domain/entity/user_entity.dart';
import '../../domain/entity/entity.dart';

part 'UserModel.g.dart'; // Make sure this matches the exact file name

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

  // Constructor
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhotoUrl,
  }) : super(
    id: id,
    name: name,
    email: email,
    phone: phone,
    profilePhotoUrl: profilePhotoUrl,
  );

  // Factory constructor for Firestore integration
  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] as String? ?? '', // Default to empty string if null
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profilePhotoUrl: json['profilePhoto'] as String?, // Safely cast and handle null
    );
  }

  // Convert the model to Firestore-compatible format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (profilePhotoUrl != null) 'profilePhoto': profilePhotoUrl, // Include only if not null
    };
  }

  // Convert the model to JSON (useful for APIs or other uses)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }

  // Useful for debugging
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, profilePhotoUrl: $profilePhotoUrl)';
  }
}