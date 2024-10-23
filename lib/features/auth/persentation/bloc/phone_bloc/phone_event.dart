import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_recommendation_b1/features/auth/domain/entity/phone_number_entities.dart';

abstract class PhoneAuthEvent {}

class SubmittedPhoneNumber extends PhoneAuthEvent {
  String phoneNumber;

  SubmittedPhoneNumber({required this.phoneNumber});
}

class SignIn extends PhoneAuthEvent {
  String otpCode;

  SignIn({required this.otpCode});
}
