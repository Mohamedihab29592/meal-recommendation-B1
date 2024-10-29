 import 'package:meal_recommendation_b1/features/auth/domain/entity/user_entity.dart';

import '../../domain/repository/auth_repository.dart';
import '../data_source_impl/local_impl/auth_local_data_source_impl.dart';
import '../data_source_impl/remote_impl/auth_remote_data_source_Impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl authRemoteDataSource;
  final AuthLocalDataSourceImpl authLocalDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<UserEntity?> loginWithEmailAndPassword(String email, String password) async {
    final result = await authRemoteDataSource.loginWithEmailAndPassword(email, password);
    if (result != null) {
      return UserEntity(
        uid: result['uid'],
        name: result['name'],
        email: result['email'],
        phone: result['phone']??'',
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
print(' rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    final result = await authRemoteDataSource.loginWithGoogle();
    if (result != null) {
      return UserEntity(
        uid: result['uid'],
        name: result['name'],
        email: result['email'],
        phone: result['phone']??'',
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

  @override
  Future<void> saveUser(UserEntity user, bool rememberMe) async {
    await authLocalDataSource.saveUser(user, rememberMe);
  }

  @override
  Future<UserEntity?> getUser() async {
    return await authLocalDataSource.getUser();
  }

  @override
  Future<void> clearUser() async {
    await authLocalDataSource.clearUser();
  }

}