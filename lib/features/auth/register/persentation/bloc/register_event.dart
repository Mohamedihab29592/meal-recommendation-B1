part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterWithEmailEvent extends RegisterEvent {
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

class LoginWithGoogleEvent extends RegisterEvent {}
