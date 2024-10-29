 import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entity/phone_number_entities.dart';
import '../../../domain/entity/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>?> loginWithEmailAndPassword(String email, String password);
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<Map<String, dynamic>?> loginWithGoogle();
  Future<void> logout();
  Future<UserEntity?> getSavedUser();



}