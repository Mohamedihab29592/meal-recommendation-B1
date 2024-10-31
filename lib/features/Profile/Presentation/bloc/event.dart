
import '../../domain/entity/entity.dart';

abstract class UserProfileEvent {}

class LoadUserProfile extends UserProfileEvent {
  final String userId;

  LoadUserProfile(this.userId);
}

class UpdateUserProfile extends UserProfileEvent {
  final User updatedUser;

  UpdateUserProfile(this.updatedUser);
}