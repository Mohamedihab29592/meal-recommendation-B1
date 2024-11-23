
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class LoginWithEmailUseCase {
  final AuthRepository repository;

  LoginWithEmailUseCase(this.repository);

  Future<LoginResult> call(String email, String password) async {
    try {
      final user = await repository.loginWithEmailAndPassword(email, password);

      if (user != null) {
        final isNewUser = await repository.isNewUser(user.id);
        final isFirstLogin = await repository.isFirstLogin(user.id);

        return LoginResult(
            user: user,
            isNewUser: isNewUser,
            isFirstLogin: isFirstLogin
        );
      }

      return LoginResult(user: null, isNewUser: false, isFirstLogin: false);
    } catch (e) {
      rethrow;
    }
  }
}

class LoginResult {
  final UserEntity? user;
  final bool isNewUser;
  final bool isFirstLogin;

  LoginResult({
    required this.user,
    required this.isNewUser,
    required this.isFirstLogin
  });
}