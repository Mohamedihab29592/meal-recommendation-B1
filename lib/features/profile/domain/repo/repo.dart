import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/features/Profile/data/Model/UserModel.dart';

import '../entity/entity.dart';

abstract class UserRepository {
  Future<User> getUserProfile(String userId);
  Future<void> updateUserProfile(UserModel user);

  Future<Either<Unit, String>> uploadUserImage(
      {required File newImage, String? oldImage});
}
