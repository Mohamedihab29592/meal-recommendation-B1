import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/remote/auth_remote_data_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<UserEntity?> loginWithEmailAndPassword(
      String email, String password) async {
    final result =
        await authRemoteDataSource.loginWithEmailAndPassword(email, password);
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
  Future<void> logout() async {
    await authRemoteDataSource.logout();
  }
}
