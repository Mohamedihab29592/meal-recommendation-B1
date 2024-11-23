 import '../entity/user_entity.dart';

 abstract class AuthRepository {
   Future<UserEntity?> loginWithEmailAndPassword(String email, String password);
   Future<UserEntity?> loginWithGoogle();
   Future<void> logout();
   Future<bool> isNewUser(String uid);
   Future<bool> isFirstLogin(String uid);
   Future<UserEntity?> getUserData(String uid);

 }
