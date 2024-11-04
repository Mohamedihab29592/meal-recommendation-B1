import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/data/data_source/base_remote_data_source.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/domin/repository/base_otp_repository.dart';

import '../../../../../core/failure/failure.dart';
import '../../domin/entites/phone_number_entities.dart';

class OTPRepository implements BaseOTPRepository{
  final BaseOTPRemoteDataSource _baseOTPRemoteDataSource;
  OTPRepository(this._baseOTPRemoteDataSource);

  @override
  Future<Either<Failure, void>> signInWithCredential(
      PhoneAuthCredential credential) async {
    try {
      await _baseOTPRemoteDataSource.signInWithCredential(credential);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhoneNumber(
      PhoneNumberEntities phoneData) async {
    try {
      await _baseOTPRemoteDataSource.verifyPhoneNumber(phoneData);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}