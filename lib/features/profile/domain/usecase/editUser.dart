import '../entity/entity.dart';
import '../repo/repo.dart';

class UpdateUserProfileUseCase {
  final UserRepository repository;

  UpdateUserProfileUseCase(this.repository);


  Future<void> call(User user) async {
    await repository.updateUserProfile(user);
  }
}