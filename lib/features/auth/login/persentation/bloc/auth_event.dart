
 import '../../domain/entity/user_entity.dart';

abstract class AuthEvent {}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailEvent(this.email, this.password);
}
class LoginWithGoogleEvent extends AuthEvent {}

class GetSavedUserEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

 class SaveUserEvent extends AuthEvent {
   final UserEntity user;
   final bool rememberMe;

   SaveUserEvent({
     required this.user,
     this.rememberMe = false,
   });}