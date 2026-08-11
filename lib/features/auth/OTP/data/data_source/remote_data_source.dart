import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_recommendation_b1/core/failure/failure.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/data/data_source/base_remote_data_source.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/data/network/handle_firebase_phone_exception.dart';

import '../../domin/entites/phone_number_entities.dart';
import '../network/handle_firebase_signin_with_credential_exception.dart';

class RemoteDataSource implements BaseOTPRemoteDataSource {
  @override
  Future<void> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw handleSignInwWithCredentialException(e);
    }
  }

  @override
  Future<void> verifyPhoneNumber(PhoneNumberEntities phoneData) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneData.phoneNumber,
        verificationCompleted: phoneData.verificationCompleted,
        verificationFailed: phoneData.verificationFailed,
        codeSent: phoneData.codeSent,
        codeAutoRetrievalTimeout: phoneData.codeAutoRetrievalTimeout,
      );
    } on FirebaseAuthException catch (e) {
      throw handleFirebasePhoneException(e);
    }
  }
}
