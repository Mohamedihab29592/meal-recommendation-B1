class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? profilePhoto;
  final String? phone;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.profilePhoto, required this.phone,
  });
}