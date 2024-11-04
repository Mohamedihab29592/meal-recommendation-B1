import '../entity/user_entity.dart';
import '../repository/register_repository.dart';

class LoginWithGoogleUseCase {
  final RegisterRepository repository;

  LoginWithGoogleUseCase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.loginWithGoogle();
  }
}
