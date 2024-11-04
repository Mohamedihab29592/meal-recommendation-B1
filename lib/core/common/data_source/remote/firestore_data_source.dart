import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/entity/user_entity.dart';

abstract class FirebaseFirestoreDataSource {
  Future<Either<FirebaseErrorModel, Unit>> addNewUser(
      {required UserEntity user});
  Future<Either<FirebaseErrorModel, UserEntity>> getUserInfo(
      {required String email});
  Future<Either<FirebaseErrorModel, Unit>> updateUserInfo({
    required String email,
    required Map<String, dynamic> body,
  });
}
