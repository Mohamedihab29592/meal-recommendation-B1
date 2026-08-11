import '../entity/entity.dart';
import '../repo/repo.dart';

class GetUserProfileUseCase {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);


  Future<User> call(String userId) async {
    return await repository.getUserProfile(userId);
  }
}