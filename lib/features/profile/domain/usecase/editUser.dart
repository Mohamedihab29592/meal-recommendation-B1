import 'package:meal_recommendation_b1/features/Profile/data/Model/UserModel.dart';
import '../entity/entity.dart';
import '../repo/repo.dart';

class UpdateUserProfileUseCase {
  final UserRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> call(User user) async {
    UserModel userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        profilePhotoUrl: user.profilePhotoUrl);
    await repository.updateUserProfile(userModel as User);
  }
}
