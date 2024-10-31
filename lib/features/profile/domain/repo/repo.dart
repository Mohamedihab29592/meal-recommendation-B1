import '../entity/entity.dart';

abstract class UserRepository {
  Future<User> getUserProfile(String userId);
  Future<void> updateUserProfile(User user);
}
