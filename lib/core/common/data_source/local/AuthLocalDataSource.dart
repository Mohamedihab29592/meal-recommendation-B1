import '../../../../features/auth/register/domain/entity/user_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserEntity user);
  Future<UserEntity?> getUser();
  Future<void> clearUser();
}
