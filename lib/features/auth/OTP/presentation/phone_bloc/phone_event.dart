import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneAuthEvent {}

class SubmittedPhoneNumber extends PhoneAuthEvent {
  String phoneNumber;

  SubmittedPhoneNumber({required this.phoneNumber});
}

class SignIn extends PhoneAuthEvent {
  String otpCode;

  SignIn({required this.otpCode});
}
