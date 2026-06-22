import '../../../login/domain/entity/user_entity.dart';
import '../repository/register_repository.dart';

class RegisterWithGoogleUseCase {
  final RegisterRepository repository;

  RegisterWithGoogleUseCase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.loginWithGoogle();
  }
}
