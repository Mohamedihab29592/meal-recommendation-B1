import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';
import 'login_with_email_use_case.dart';

class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  Future<LoginResult> call() async {
    try {
      final user = await repository.loginWithGoogle();

      if (user != null) {
        final isNewUser = await repository.isNewUser(user.id!);
        final isFirstLogin = await repository.isFirstLogin(user.id!);

        return LoginResult(
            user: user, isNewUser: isNewUser, isFirstLogin: isFirstLogin);
      }
      return LoginResult(user: null, isNewUser: false, isFirstLogin: false);
    } catch (e) {
      rethrow;
    }
  }
}
