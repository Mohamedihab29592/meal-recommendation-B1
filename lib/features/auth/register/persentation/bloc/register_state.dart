part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterAuthenticatedState extends RegisterState {
  final UserEntity user;

  RegisterAuthenticatedState(this.user);
}

class RegisterUnauthenticatedState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState(this.message);
}
