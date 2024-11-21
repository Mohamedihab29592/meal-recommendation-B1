import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/core/common/data_source/remote/firestore_data_source.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';
import 'package:meal_recommendation_b1/features/auth/register/domain/entity/user_entity.dart';

import '../../domain/repository/register_repository.dart';
import '../../../../../core/common/data_source/remote/auth_remote_data_source.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final FirebaseFirestoreDataSource firebaseFirestoreDataSource;
  RegisterRepositoryImpl(
      this.authRemoteDataSource, this.firebaseFirestoreDataSource);

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    
    await authRemoteDataSource.registerWithEmail(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
  }

  @override
  Future<UserEntity?> loginWithGoogle() async {
    final result = await authRemoteDataSource.loginWithGoogle();
    if (result != null) {
      return UserEntity(
        uid: result['uid'],
        name: result['name'],
        email: result['email'],
        phone: result['phone'] ?? '',
      );
    }
    return null;
  }

  @override
  Future<Either<FirebaseErrorModel, Unit>> addNewUser(
      {required UserEntity user}) async {
    return await firebaseFirestoreDataSource.addNewUser(user: user);
  }
}
