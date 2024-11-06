import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_recommendation_b1/core/failure/failure.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/data/repository/repository.dart';


class SubmitOTPUseCase {
  final OTPRepository _OTPRepository;

  SubmitOTPUseCase(this._OTPRepository);

  Future<Either<Failure, void>> call(
      String otpCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);
    return await _OTPRepository.signInWithCredential(credential);
  }
}
