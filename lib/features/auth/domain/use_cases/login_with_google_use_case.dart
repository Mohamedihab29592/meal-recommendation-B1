import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.loginWithGoogle();
  }
}