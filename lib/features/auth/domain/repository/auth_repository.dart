import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> loginWithEmailAndPassword(String email, String password);

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  });

  Future<UserEntity?> loginWithGoogle();

  Future<void> logout();

  Future<UserEntity?> getSavedUser();
}
