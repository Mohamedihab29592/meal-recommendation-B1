 import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class GetSavedUserUseCase {
  final AuthRepository repository;

  GetSavedUserUseCase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.getSavedUser();
  }
}