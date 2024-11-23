sealed class AuthEvent {}

 class LoginWithEmailEvent extends AuthEvent {
   final String email;
   final String password;

   LoginWithEmailEvent({required this.email, required this.password});
 }

 class LoginWithGoogleEvent extends AuthEvent {}

 class LogoutEvent extends AuthEvent {}



 class CheckAuthStatusEvent extends AuthEvent {}