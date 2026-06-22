import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/repository/register_repository.dart';

import '../../../login/domain/entity/user_entity.dart';

class SaveUserDataInFirebaseUseCase {
  final RegisterRepository repository;

  SaveUserDataInFirebaseUseCase(this.repository);

  Future<Either<FirebaseErrorModel, Unit>> call(
      {required UserEntity user}) async {
    return await repository.addNewUser(user: user);
  }
}
