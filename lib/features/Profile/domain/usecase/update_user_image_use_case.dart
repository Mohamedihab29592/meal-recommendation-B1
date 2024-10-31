import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/repo/repo.dart';

class UploadUserProfileImage {
  final UserRepository userRepository;

  UploadUserProfileImage({required this.userRepository});
  Future<Either<Unit, String>> call(
      {required File newImage, String? oldImage}) async {
    return await userRepository.uploadUserImage(
        newImage: newImage, oldImage: oldImage);
  }
}
