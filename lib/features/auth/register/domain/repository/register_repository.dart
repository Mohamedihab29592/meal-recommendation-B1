import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';

import '../entity/user_entity.dart';

abstract class RegisterRepository {
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  });

  Future<UserEntity?> loginWithGoogle();

  Future<Either<FirebaseErrorModel, Unit>> addNewUser(
      {required UserEntity user});
}
