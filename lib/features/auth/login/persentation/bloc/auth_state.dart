import '../../domain/entity/user_entity.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  final bool isNewUser;
  final bool isFirstLogin;
  final AuthenticationMethod authMethod;

  Authenticated({
    required this.user,
    this.isNewUser = false,
    this.isFirstLogin = false,
    required this.authMethod,
  });
}

class Unauthenticated extends AuthState {
  final String? errorMessage;
  final AuthenticationMethod? lastAttemptedMethod;

  Unauthenticated({
    this.errorMessage,
    this.lastAttemptedMethod,
  });
}

class AuthError extends AuthState {
  final String errorMessage;
  final AuthErrorType errorType;

  AuthError({
    required this.errorMessage,
    required this.errorType,
  });
}

// Enums
enum AuthenticationMethod {
  email,
  google,
  apple,
  phone
}

enum AuthErrorType {
  networkError,
  invalidCredentials,
  userNotFound,
  accountDisabled,
  unknown
}