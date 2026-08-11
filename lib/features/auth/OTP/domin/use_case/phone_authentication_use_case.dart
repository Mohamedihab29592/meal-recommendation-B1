import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/core/failure/failure.dart';

import '../../data/repository/repository.dart';
import '../entites/phone_number_entities.dart';


class PhoneAuthenticationUseCase {
  final OTPRepository _OTPRepository;

  PhoneAuthenticationUseCase(this._OTPRepository);

  Future<Either<Failure, void>> call(PhoneNumberEntities phoneData) async {
    return await _OTPRepository.verifyPhoneNumber(phoneData);
  }
}
