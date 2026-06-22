import 'package:meal_recommendation_b1/core/networking/firebase_error_handler.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/local/local_data_source_impl.dart';
import '../data_source/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final LocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final result =
          await authRemoteDataSource.loginWithEmailAndPassword(email, password);

      if (result != null) {
        UserEntity user = _mapToUserEntity(result);

        // Update login tracking
        await _updateUserLoginStatus(user);

        return user;
      }
      return null;
    } catch (e) {
      FirebaseErrorHandler.handle(e);
      rethrow;
    }
  }

  @override
  Future<UserEntity?> loginWithGoogle() async {
    try {
      final result = await authRemoteDataSource.loginWithGoogle();

      if (result != null) {
        UserEntity user = _mapToUserEntity(result);

        // Update login tracking
        await _updateUserLoginStatus(user);

        return user;
      }
      return null;
    } catch (e) {
      FirebaseErrorHandler.handle(e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authRemoteDataSource.logout();
      await localDataSource.clearLoginStatus();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isNewUser(String uid) async {
    try {
      // Check if user exists in local storage or remote source
      bool existsLocally = await localDataSource.checkUserExists(uid);
      return !existsLocally;
    } catch (e) {
      return true;
    }
  }

  @override
  Future<bool> isFirstLogin(String uid) async {
    try {
      int loginCount = await localDataSource.getLoginCount(uid);
      return loginCount <= 1;
    } catch (e) {
      return true;
    }
  }

  // Utility method to convert Map to UserEntity
  UserEntity _mapToUserEntity(Map<String, dynamic> userData) {
    return UserEntity(
      id: userData['uid'] ?? '',
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      profilePhoto: userData['profilePhoto'] ?? '',
    );
  }

  // Internal method to update login status
  Future<void> _updateUserLoginStatus(UserEntity user) async {
    try {
      // Increment login count
      await localDataSource.incrementLoginCount(user.id);

      // Save user details locally if not exists
      await localDataSource.saveUserIfNotExists(user);
    } catch (e) {
      print('Error updating login status: $e');
    }
  }

  @override
  Future<UserEntity?> getUserData(String uid) async {
    return await localDataSource.getUserData(uid);
  }
}
