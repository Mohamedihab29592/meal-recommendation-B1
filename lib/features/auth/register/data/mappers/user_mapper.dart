import '../../domain/entity/user_entity.dart';

class UserMapper {
  static UserEntity fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }
}
