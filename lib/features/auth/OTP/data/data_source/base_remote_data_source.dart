import 'package:firebase_auth/firebase_auth.dart';

import '../../domin/entites/phone_number_entities.dart';

abstract class BaseOTPRemoteDataSource{
  Future<void> verifyPhoneNumber(PhoneNumberEntities phoneNumberEntities);

  Future<void> signInWithCredential(PhoneAuthCredential credential);
}