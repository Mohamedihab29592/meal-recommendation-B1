
 import '../../domain/entity/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

 class SavedUserLoaded extends AuthState {
   final UserEntity user;

    SavedUserLoaded(this.user);

   List<Object?> get props => [user];
 }