import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failure/failure.dart';
import '../entity/phone_number_entities.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> loginWithEmailAndPassword(String email, String password);

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  });

  Future<UserEntity?> loginWithGoogle();

  Future<void> logout();

  Future<UserEntity?> getSavedUser();

  Future<Either<Failure, void>> verifyPhoneNumber(
      PhoneNumberEntities phoneData);

  Future<Either<Failure, void>> signInWithCredential(
      PhoneAuthCredential credential);
}
