import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_recommendation_b1/core/failure/failure.dart';

import '../repository/auth_repository.dart';

class SubmitOTPUseCase {
  final AuthRepository _authRepository;

  SubmitOTPUseCase(this._authRepository);

  Future<Either<Failure, void>> call(
      String otpCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);
    return await _authRepository.signInWithCredential(credential);
  }
}
