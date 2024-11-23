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

  factory UserEntity.fromJson(Map<String, dynamic> json, String id) {
    return UserEntity(
      id: id,
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      name: json['displayName'],
      profilePhoto: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': name,
      'photoUrl': profilePhoto,
    };
  }
}