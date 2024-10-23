import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/core/failure/failure.dart';

import '../entity/phone_number_entities.dart';
import '../repository/auth_repository.dart';

class PhoneAuthenticationUseCase {
  final AuthRepository _authRepository;

  PhoneAuthenticationUseCase(this._authRepository);

  Future<Either<Failure, void>> call(PhoneNumberEntities phoneData) async {
    return await _authRepository.verifyPhoneNumber(phoneData);
  }
}
