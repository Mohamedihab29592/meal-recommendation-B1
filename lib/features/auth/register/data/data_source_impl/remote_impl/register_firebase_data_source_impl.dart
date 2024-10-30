import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/core/common/data_source/remote/firestore_data_source.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_handler.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/entity/user_entity.dart';

class RegisterFirebaseDataSourceImpl implements FirebaseFirestoreDataSource {
  @override
  Future<Either<FirebaseErrorModel, Unit>> addNewUser(
      {required UserEntity user}) async {
    CollectionReference users = getIt<FirebaseFirestore>().collection('users');
    try {
      await users.add(
        {
          'name': user.name,
          'email': user.email,
          'phoneNumber': user.phone,
          'profile_pic':
              '', // at first time it will be empty string after that user can update the default image
        },
      );
      return const Right(unit);
    } catch (e) {
      return Left(
        FirebaseErrorHandler.handle(e),
      );
    }
  }

  @override
  Future<Either<FirebaseErrorModel, UserEntity>> getUserInfo(
      {required String email}) {
    throw Exception("Not Used Here");
  }

  @override
  Future<Either<FirebaseErrorModel, Unit>> updateUserInfo(
      {required String email, required Map<String, dynamic> body}) {
    throw Exception("Not Used Here");
  }
}
