
 abstract class AuthEvent {}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailEvent(this.email, this.password);
}

class RegisterWithEmailEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  RegisterWithEmailEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}

class LoginWithGoogleEvent extends AuthEvent {}

class GetSavedUserEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}