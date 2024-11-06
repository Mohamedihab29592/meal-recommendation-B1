import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/failure/failure.dart';
import '../entites/phone_number_entities.dart';

abstract class BaseOTPRepository {
  Future<Either<Failure, void>> verifyPhoneNumber(
      PhoneNumberEntities phoneData);

  Future<Either<Failure, void>> signInWithCredential(
      PhoneAuthCredential credential);
}
