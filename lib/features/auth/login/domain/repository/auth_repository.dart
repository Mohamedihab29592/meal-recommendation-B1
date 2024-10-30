 import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> loginWithEmailAndPassword(String email, String password);

  Future<UserEntity?> loginWithGoogle();

  Future<void> logout();

  Future<UserEntity?> getSavedUser();
  Future<void> saveUser(UserEntity user, bool rememberMe);
  Future<void> clearUser();


}
