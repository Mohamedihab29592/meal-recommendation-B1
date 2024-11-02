
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class LoginWithEmailUseCase {
  final AuthRepository repository;

  LoginWithEmailUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    return await repository.loginWithEmailAndPassword(email, password);
  }
}