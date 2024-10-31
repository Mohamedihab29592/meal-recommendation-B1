
import '../../domain/entity/entity.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final User user;

  UserProfileLoaded(this.user);
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError(this.message);
}

class UserProfileUpdating extends UserProfileState {}

class UserProfileUpdated extends UserProfileState {}