 import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> loginWithEmailAndPassword(String email, String password);

  Future<UserEntity?> loginWithGoogle();

  Future<void> logout();

}
