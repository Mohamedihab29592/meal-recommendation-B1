import 'package:meal_recommendation_b1/features/auth/domain/entity/user_entity.dart';

import '../../domain/repository/auth_repository.dart';
import '../data_source/local/AuthLocalDataSource.dart';
import '../data_source/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<UserEntity?> loginWithEmailAndPassword(String email, String password) async {
    final result = await authRemoteDataSource.loginWithEmailAndPassword(email, password);
    if (result != null) {
      return UserEntity(
        uid: result['uid'],
        name: result['name'],
        email: result['email'],
        phone: result['phone'],
      );
    }
    return null;
  }

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception("Passwords do not match.");
    }
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
        phone: result['phone'],
      );
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await authRemoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getSavedUser() async {
    return await authLocalDataSource.getUser();
  }
}